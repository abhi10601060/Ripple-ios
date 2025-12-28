//
//  MarkAllNearbyDeviceLostUseCase.swift
//  Ripple
//
//  Created by Abhishek Velekar on 26/12/25.
//

import Foundation
import FactoryKit

struct MarkAllNearbyDeviceLostUseCase{
    @Injected(\.nearbyConnectionRepo) var nearbyConnectionRepo: NearbyConnectionRepo
    @Injected(\.nerbyConnectionManager) var nearbyConnectionManager: NearbyConnectionManager
    
    func invoke() async{
        nearbyConnectionManager.connectedDevices.forEach{ device in
            Task{
                await nearbyConnectionManager.disconnectFromDevice(endpointId: device.endpointId)
            }
        }
        await nearbyConnectionRepo.markAllDeviceLost()
    }
}
