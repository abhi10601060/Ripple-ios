//
//  GetConnectedDevicesUseCase.swift
//  Ripple
//
//  Created by Abhishek Velekar on 23/12/25.
//

import Foundation


import Foundation
import Combine
import FactoryKit

struct GetConnectedDevicesUseCase {
    
    @Injected(\.nearbyConnectionRepo) var nearbyConnectionRepo: NearbyConnectionRepo
    
    func invoke() -> AnyPublisher<[NearbyDeviceDomain], Never>{
        return nearbyConnectionRepo.getNearbyConnectedDevices()
            .map{ devices in
                devices.map{ device in
                    device.toNearbyDeviceDomain()
                }
            }
            .eraseToAnyPublisher()
    }
}
