//
//  NearbyDevice.swift
//  Ripple
//
//  Created by Abhishek Velekar on 17/12/25.
//

import Foundation

struct NearbyDevice: Identifiable, Equatable {
    let id: String
    let endpointId: String
    let deviceName: String
    let model: String
    var connectionState: ConnectionState
    var lastSeen: Int64
    var signalStrength: Int

    init(
        id: String,
        endpointId: String,
        deviceName: String,
        model: String,
        connectionState: ConnectionState = .disconnected,
        lastSeen: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        signalStrength: Int = 0
    ) {
        self.id = id
        self.endpointId = endpointId
        self.deviceName = deviceName
        self.model = model
        self.connectionState = connectionState
        self.lastSeen = lastSeen
        self.signalStrength = signalStrength
    }
}


extension NearbyDevice{
    
    // Mock instance
    static let mock = NearbyDevice(
        id: "123",
        endpointId: "abc",
        deviceName: "abcdefghijk",
        model: "xyz",
        connectionState: .connected,
        lastSeen: Int64(Date().timeIntervalSince1970 * 1000),
        signalStrength: 100
    )
}


//struct NearbyDevice: Identifiable, Equatable {
//    let id: String
//    let deviceName: String
//    var connectionState: ConnectionState
//    
//    init(id: String = UUID().uuidString, deviceName: String, connectionState: ConnectionState) {
//        self.id = id
//        self.deviceName = deviceName
//        self.connectionState = connectionState
//    }
//}
//

