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
    
    let getDiscoveredDevicesUseCase: GetDiscoveredDevicesUseCase = GetDiscoveredDevicesUseCase()
    let startAdvertisingUseCase: StartAdvertisingUseCase = StartAdvertisingUseCase()
    let startDiscoveryUseCase: StartDiscoveryUseCase = StartDiscoveryUseCase()
    
    @Injected(\.nerbyConnectionManager) var nearByConnectionManager: NearbyConnectionManager
    
    
    @Published var discoveredDevices: [NearbyDeviceDomain] = []
    
    init() {
        observeDiscoveredDevices()
        
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
}
