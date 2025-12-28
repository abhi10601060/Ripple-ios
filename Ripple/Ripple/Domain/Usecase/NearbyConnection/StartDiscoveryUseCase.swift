//
//  StartDiscoveryUseCase.swift
//  Ripple
//
//  Created by Abhishek Velekar on 24/12/25.
//

import Foundation
import FactoryKit

struct StartDiscoveryUseCase{
    @Injected(\.nearbyConnectionRepo) var nearByConnectionRepo: NearbyConnectionRepo
    
    func invoke() {
        nearByConnectionRepo.startDiscovery()
    }
}
