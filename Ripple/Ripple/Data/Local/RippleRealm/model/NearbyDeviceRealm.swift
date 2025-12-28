//
//  NearbyDeviceRealm.swift
//  Ripple
//
//  Created by Abhishek Velekar on 26/12/25.
//

import Foundation
import RealmSwift
internal import Realm

class NearbyDeviceRealm: Object {

    @Persisted(primaryKey: true) var id: String                // Android ID
    @Persisted var endpointId: String                          // Endpoint ID for communication
    @Persisted var deviceName: String                          // User's broadcast name
    @Persisted var model: String                               // Device model
    @Persisted var savedDeviceName: String?                    // Optional saved name by receiver
    @Persisted var _connectionState: String = ConnectionState.discovered.rawValue
    @Persisted var _visibility: String = DeviceVisibility.online.rawValue
    @Persisted var lastSeen: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    @Persisted var signalStrength: Int = 100
    @Persisted var recentMessage: TextMessageRealm?            // Relationship
    @Persisted var allMessages = List<TextMessageRealm>()      // One-to-many
    
    // Computed properties for enum conversion
    var connectionState: ConnectionState {
        get { ConnectionState(rawValue: _connectionState) ?? .discovered }
        set { _connectionState = newValue.rawValue }
    }

    var visibility: DeviceVisibility {
        get { DeviceVisibility(rawValue: _visibility) ?? .online }
        set { _visibility = newValue.rawValue }
    }

    // Default initializer
    override init() {
        super.init()
    }

    // Convenience initializer
    convenience init(
        id: String,
        endpointId: String,
        deviceName: String,
        model: String
    ) {
        self.init()
        self.id = id
        self.endpointId = endpointId
        self.deviceName = deviceName
        self.model = model
    }
}


extension NearbyDevice{
    func toNearbyDeviceRealm() -> NearbyDeviceRealm {
        .init(
            id: self.id,
            endpointId: self.endpointId,
            deviceName: self.deviceName,
            model: self.model
        )
    }
}
