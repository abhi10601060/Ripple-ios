//
//  GetNearbyDeviceById.swift
//  Ripple
//
//  Created by Abhishek Velekar on 27/12/25.
//

import Foundation
import Combine
import FactoryKit

struct GetNearbyDeviceByIdUseCase{
    
    @Injected(\.nearbyConnectionRepo) var nearbyConnectionRepo: NearbyConnectionRepo
    
    func invoke(deviceId: String) -> AnyPublisher<NearbyDeviceDomain?, Never>{
        return nearbyConnectionRepo.getNearbyDeviceById(deviceId: deviceId)
            .map{ device in
                return device?.toNearbyDeviceDomain()
            }
            .eraseToAnyPublisher()
    }
}
