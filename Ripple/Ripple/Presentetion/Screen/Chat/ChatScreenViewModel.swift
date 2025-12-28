//
//  ChatScreenViewModel.swift
//  Ripple
//
//  Created by Abhishek Velekar on 25/12/25.
//

import Combine
import Foundation

@MainActor
class ChatScreenViewModel: ObservableObject {
    
    private let getNearbyDeviceByIdUseCase: GetNearbyDeviceByIdUseCase = GetNearbyDeviceByIdUseCase()
    private let connectNearbyDeviceUseCase: ConnectNearbyDeviceUseCase = ConnectNearbyDeviceUseCase()

    let sendTextMessageUseCase: SendTextMessageUseCase =
        SendTextMessageUseCase()
    let getAllMessgaesUseCase: GetAllMessagesUseCase = GetAllMessagesUseCase()

    @Published var allMessages: [TextMessageDomain] = []
    @Published var currentNearbyDeviceDomain: NearbyDeviceDomain? = nil

    var currentNearbyDevice: NearbyDeviceDomain = NearbyDeviceDomain.mock

    func assignCurrentDevice(currentNearbyDevice: NearbyDeviceDomain) {
        self.currentNearbyDevice = currentNearbyDevice

//        observeAllMessagesForCurrentUser()
        getNearbyDeviceByIdUseCase.invoke(deviceId: currentNearbyDevice.id)
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .assign(to: &$currentNearbyDeviceDomain)
    }

    func sendMessage(_ message: String) {
        let textMessage = TextMessageDomain(
            content: message,
            senderId: "abcdefg",
            receiverId: currentNearbyDevice.id,
            endpointId: currentNearbyDevice.endpointId
        )

        Task {
            let success = await sendTextMessageUseCase.invoke(
                message: textMessage
            )

            if !success {
                // add errror message or notifier
            }
        }
    }

    func observeAllMessagesForCurrentUser() {
        getAllMessgaesUseCase.invoke(userId: currentNearbyDevice.id)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .map { messages in
                messages.sorted {
                    $0.timestamp > $1.timestamp
                }
            }
            .assign(to: &$allMessages)

    }
    
    func connectToCurrentNearbyDevice(){
        guard let currentDevice = currentNearbyDeviceDomain else {
            return
        }
        print("connecting to \(currentDevice.deviceName)")
        Task{
            let success = await connectNearbyDeviceUseCase.invoke(endpointId: currentDevice.endpointId)
            if !success {
                // add a error message
            }
        }
    }

}
