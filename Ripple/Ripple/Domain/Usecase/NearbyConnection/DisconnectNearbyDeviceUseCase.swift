//
//  DisconnectNearbyDeviceUseCase.swift
//  Ripple
//
//  Created by Abhishek Velekar on 24/12/25.
//

import Foundation
import FactoryKit

struct DisconnectNearbyDeviceUseCase{
    @Injected(\.nearbyConnectionRepo) var nearbyConnectionRepo: NearbyConnectionRepo
    
    func invoke(endpointId: String) async -> Bool{
        return await nearbyConnectionRepo.disconnectNearbyDevice(endpoitId: endpointId)
    }
}
