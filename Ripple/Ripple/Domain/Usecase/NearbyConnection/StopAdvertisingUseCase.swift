//
//  StopAdvertisingUseCase.swift
//  Ripple
//
//  Created by Abhishek Velekar on 24/12/25.
//

import Foundation
import FactoryKit

struct StopAdvertisingUseCase{
    
    @Injected(\.nearbyConnectionRepo) var nearByConnectionRepo: NearbyConnectionRepo
    
    func invoke() {
        nearByConnectionRepo.stopAdvertising()
    }
}
