//
//  NearbyDeviceDomain.swift
//  Ripple
//
//  Created by Abhishek Velekar on 17/12/25.
//

import Foundation

struct NearbyDeviceDomain {
    let id: String
    let endpointId: String
    let deviceName: String
    let model: String
    let savedDeviceName: String?
    let connectionState: ConnectionState
    let visibility: DeviceVisibility
    let lastSeen: Int64
    let signalStrength: Int
    let recentMessage: TextMessageDomain?
    let allMessages: [TextMessageDomain]

    init(
        id: String,
        endpointId: String,
        deviceName: String,
        model: String,
        savedDeviceName: String? = nil,
        connectionState: ConnectionState = .discovered,
        visibility: DeviceVisibility = .online,
        lastSeen: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        signalStrength: Int = 100,
        recentMessage: TextMessageDomain? = nil,
        allMessages: [TextMessageDomain] = []
    ) {
        self.id = id
        self.endpointId = endpointId
        self.deviceName = deviceName
        self.model = model
        self.savedDeviceName = savedDeviceName
        self.connectionState = connectionState
        self.visibility = visibility
        self.lastSeen = lastSeen
        self.signalStrength = signalStrength
        self.recentMessage = recentMessage
        self.allMessages = allMessages
    }
}


extension NearbyDeviceDomain{
    static let mock = NearbyDeviceDomain(
        id: "123",
        endpointId: "abc",
        deviceName: "abcdefghijk",
        model: "xyz",
        connectionState: .connected,
        visibility: .online,
        lastSeen: Int64(Date().timeIntervalSince1970 * 1000),
        signalStrength: 100,
        recentMessage: TextMessageDomain.mock,
        allMessages: [TextMessageDomain.mock, TextMessageDomain.mock]
    )
}
