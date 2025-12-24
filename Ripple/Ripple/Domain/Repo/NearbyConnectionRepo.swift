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
    
    func getNearbyDiscoveredDevices() -> AnyPublisher<[NearbyDevice], Never>
    
    func getNearbyConnectedDevices() -> AnyPublisher<[NearbyDevice], Never>
}
