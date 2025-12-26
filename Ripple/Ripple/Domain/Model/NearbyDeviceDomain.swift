//
//  NearbyDeviceDomain.swift
//  Ripple
//
//  Created by Abhishek Velekar on 17/12/25.
//

import Foundation

struct NearbyDeviceDomain: Identifiable, Hashable {
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

extension NearbyDevice{
    func toNearbyDeviceDomain() -> NearbyDeviceDomain {
        return NearbyDeviceDomain(
            id: self.id,
            endpointId: self.endpointId,
            deviceName: self.deviceName,
            model: self.model,
            savedDeviceName: "",
            connectionState: self.connectionState,
            visibility: .online,
            lastSeen: self.lastSeen
        )
    }
}

extension NearbyDeviceRealm{
    func toNearbyDeviceDomain() -> NearbyDeviceDomain {
        return NearbyDeviceDomain(
            id: self.id,
            endpointId: self.endpointId,
            deviceName: self.deviceName,
            model: self.model,
            savedDeviceName: self.savedDeviceName,
            connectionState: self.connectionState,
            visibility: self.visibility,
            lastSeen: self.lastSeen,
            recentMessage: self.recentMessage?.toTextMessageDomain(),
            allMessages: self.allMessages.map{ $0.toTextMessageDomain() }
            )
    }
}


extension NearbyDeviceDomain{
    static let mock = NearbyDeviceDomain(
        id: "123",
        endpointId: "abc",
        deviceName: "Abhis' Phone",
        model: "xyz",
        connectionState: .connected,
        visibility: .online,
        lastSeen: Int64(Date().timeIntervalSince1970 * 1000),
        signalStrength: 100,
        recentMessage: TextMessageDomain.mock,
        allMessages: [TextMessageDomain.mock, TextMessageDomain.mock1, TextMessageDomain.mock2, TextMessageDomain.mock3]
    )
    
    static let mock1 = NearbyDeviceDomain(
        id: "456",
        endpointId: "efg",
        deviceName: "Abhis' Mac",
        model: "xyz",
        connectionState: .connected,
        visibility: .online,
        lastSeen: Int64(Date().timeIntervalSince1970 * 1000),
        signalStrength: 100,
        recentMessage: TextMessageDomain.mock,
        allMessages: [TextMessageDomain.mock, TextMessageDomain.mock1, TextMessageDomain.mock2, TextMessageDomain.mock3]
    )
    
    static let mock2 = NearbyDeviceDomain(
        id: "789",
        endpointId: "ijk",
        deviceName: "Abhis' Tab",
        model: "xyz",
        connectionState: .connected,
        visibility: .online,
        lastSeen: Int64(Date().timeIntervalSince1970 * 1000),
        signalStrength: 100,
        recentMessage: TextMessageDomain.mock,
        allMessages: [TextMessageDomain.mock, TextMessageDomain.mock1, TextMessageDomain.mock2, TextMessageDomain.mock3]
    )
}


