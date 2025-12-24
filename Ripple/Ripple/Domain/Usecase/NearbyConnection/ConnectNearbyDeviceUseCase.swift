//
//  ConnectToNearbyDeviceUseCase.swift
//  Ripple
//
//  Created by Abhishek Velekar on 24/12/25.
//

import Foundation
import FactoryKit

struct ConnectNearbyDeviceUseCase{
    @Injected(\.nearbyConnectionRepo) var nearbyConnectionRepo: NearbyConnectionRepo
    
    func invoke(endpointId: String) async -> Bool {
        return await nearbyConnectionRepo.connectNearbyDevice(endpoitId: endpointId)
    }
}
