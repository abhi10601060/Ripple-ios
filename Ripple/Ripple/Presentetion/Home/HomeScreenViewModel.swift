//
//  HomeScreenViewModel.swift
//  Ripple
//
//  Created by Abhishek Velekar on 23/12/25.
//

import Foundation
import Combine
import FactoryKit


@MainActor
class HomeScreenViewModel: ObservableObject {
    
    private let getDiscoveredDevicesUseCase: GetDiscoveredDevicesUseCase = GetDiscoveredDevicesUseCase()
    private let getConnectedDevicesUseCase: GetConnectedDevicesUseCase = GetConnectedDevicesUseCase()
    private let startAdvertisingUseCase: StartAdvertisingUseCase = StartAdvertisingUseCase()
    private let startDiscoveryUseCase: StartDiscoveryUseCase = StartDiscoveryUseCase()
    private let connectNearbyDeviceUseCase: ConnectNearbyDeviceUseCase = ConnectNearbyDeviceUseCase()
    private let disconnectNearbyDeviceUseCase: DisconnectNearbyDeviceUseCase = DisconnectNearbyDeviceUseCase()
    
    @Injected(\.nerbyConnectionManager) var nearByConnectionManager: NearbyConnectionManager
    
    
    @Published var discoveredDevices: [NearbyDeviceDomain] = []
    @Published var connectedDevices: [NearbyDeviceDomain] = []
    
    init() {
        observeDiscoveredDevices()
        observeConnectedDevices()
        
        startDiscoveryUseCase.invoke()
        startAdvertisingUseCase.invoke()
    }
    
    private func observeDiscoveredDevices() {
        print("observer added for discovered devices...")
        getDiscoveredDevicesUseCase.invoke()
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: &$discoveredDevices)
    }
    
    private func observeConnectedDevices() {
        getConnectedDevicesUseCase.invoke()
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: &$connectedDevices)
    }
    
    func connectToNearbyDevice(device: NearbyDeviceDomain){
        print("connecting to \(device.deviceName)")
        Task{
            let success = await connectNearbyDeviceUseCase.invoke(endpointId: device.endpointId)
            if !success {
                // add a error message
            }
        }
    }
    
    func disconnectFromNearbyDevice(device: NearbyDeviceDomain){
        print("disconnecting from \(device.deviceName)")
        Task{
            let success = await disconnectNearbyDeviceUseCase.invoke(endpointId: device.endpointId)
            if !success {
                // add a error message to show on screen
            }
        }
    }
    
}
