//
//  GetDiscoveredDevicesUseCase.swift
//  Ripple
//
//  Created by Abhishek Velekar on 23/12/25.
//

import Foundation
import Combine
import FactoryKit

struct GetDiscoveredDevicesUseCase {
    
    @Injected(\.nearbyConnectionRepo) var nearbyConnectionRepo: NearbyConnectionRepo
    
    func invoke() -> AnyPublisher<[NearbyDeviceDomain], Never>{
        return nearbyConnectionRepo.getNearbyDiscoveredDevices()
            .map{ devices in
                print("devices in GetDiscoveredDevicesUseCase: \(devices)")
                return devices.map{ device in
                    print("device in GetDiscoveredDevicesUseCase: \(device.deviceName)")
                    return device.toNearbyDeviceDomain()
                }
            }
            .eraseToAnyPublisher()
    }
}
