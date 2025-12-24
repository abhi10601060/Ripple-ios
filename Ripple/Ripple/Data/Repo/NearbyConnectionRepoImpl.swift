//
//  NearbyConnectionRepo.swift
//  Ripple
//
//  Created by Abhishek Velekar on 23/12/25.
//

import Foundation
import Combine

struct NearbyConnectionRepoImpl: NearbyConnectionRepo {

    let nearbyShareManager: NearbyConnectionManager
    
    init(nearbyShareManager: NearbyConnectionManager) {
        self.nearbyShareManager = nearbyShareManager
    }
    
    func startDiscovery() {
        Task{
            await nearbyShareManager.startDiscovery()
        }
    }
    
    func stopDiscovery() {
        Task{
            await nearbyShareManager.stopDiscovery()
        }
    }
    
    func startAdvertising() {
        Task{
            await nearbyShareManager.startAdvertising()
        }
    }
    
    func stopAdvertising() {
        Task{
            await nearbyShareManager.stopAdvertising()
        }
    }
    
    func connectNearbyDevice(endpoitId: String) async -> Bool {
        return await nearbyShareManager.connectToDevice(endpointId: endpoitId)
    }
    
    func disconnectNearbyDevice(endpoitId: String) async -> Bool {
        return await nearbyShareManager.disconnectFromDevice(endpointId: endpoitId)
    }
    
    func getNearbyDiscoveredDevices() -> AnyPublisher<[NearbyDevice], Never> {
        return nearbyShareManager.$discoveredDevices.eraseToAnyPublisher()
    }
    
    func getNearbyConnectedDevices() -> AnyPublisher<[NearbyDevice], Never> {
        return nearbyShareManager.$connectedDevices.eraseToAnyPublisher()
    }
}
