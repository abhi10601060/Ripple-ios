//
//  ConnectToNearbyDeviceUseCase.swift
//  Ripple
//
//  Created by Abhishek Velekar on 24/12/25.
//

import Foundation
import FactoryKit

struct StartConnectingToNearbyDeviceUseCase{
    @Injected(\.nearbyConnectionRepo) var nearbyConnectionRepo: NearbyConnectionRepo
    
    func invoke(){
        
    }
}
