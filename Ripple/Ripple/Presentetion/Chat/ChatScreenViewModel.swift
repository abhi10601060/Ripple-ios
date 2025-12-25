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

    let sendTextMessageUseCase: SendTextMessageUseCase =
        SendTextMessageUseCase()
    let getAllMessgaesUseCase: GetAllMessagesUseCase = GetAllMessagesUseCase()

    @Published var allMessages: [TextMessageDomain] = []

    var currentNearbyDevice: NearbyDeviceDomain = NearbyDeviceDomain.mock

    func assignCurrentDevice(currentNearbyDevice: NearbyDeviceDomain) {
        self.currentNearbyDevice = currentNearbyDevice

        observeAllMessagesForCurrentUser()
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

}
