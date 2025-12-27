//
//  NearbyConnectionRepo.swift
//  Ripple
//
//  Created by Abhishek Velekar on 23/12/25.
//

import Foundation
import Combine

protocol NearbyConnectionRepo {
    
    func startDiscovery()
    
    func stopDiscovery()
    
    func startAdvertising()
    
    func stopAdvertising()
    
    func connectNearbyDevice(endpoitId: String) async -> Bool
    
    func disconnectNearbyDevice(endpoitId: String) async -> Bool
    
    func getNearbyDiscoveredDevices() -> AnyPublisher<[NearbyDeviceRealm], Never>
    
    func getNearbyConnectedDevices() -> AnyPublisher<[NearbyDeviceRealm], Never>
    
    func markAllDeviceLost() async
}
