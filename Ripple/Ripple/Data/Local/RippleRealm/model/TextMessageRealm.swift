//
//  TextMessageRealm.swift
//  Ripple
//
//  Created by Abhishek Velekar on 26/12/25.
//

import Foundation
import RealmSwift
internal import Realm

class TextMessageRealm: Object {
    // Primary key
    @Persisted(primaryKey: true) var id: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    
    // Message details
    @Persisted var content: String = ""
    @Persisted var senderId: String = ""
    @Persisted var receiverId: String = ""
    
    // Timestamp
    @Persisted var timestamp: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    
    // Internal status string for Realm storage
    @Persisted var _deliveryStatus: String = DeliveryStatus.failed.rawValue
    
    // Computed property for enum mapping
    var deliveryStatus: DeliveryStatus {
        get { DeliveryStatus(rawValue: _deliveryStatus) ?? .failed }
        set { _deliveryStatus = newValue.rawValue }
    }

    // Default initializer
    override init() {
        super.init()
    }

    // Convenience initializer
    convenience init(id: Int64, content: String, senderId: String, receiverId: String, _deliveryStatus: String) {
        self.init()
        self.id = id
        self.content = content
        self.senderId = senderId
        self.receiverId = receiverId
        self._deliveryStatus = _deliveryStatus
    }
}


extension TextMessage{
    func toTextMessageRealm() -> TextMessageRealm {
        .init(id: self.id, content: self.content, senderId: self.senderId, receiverId: self.receiverId, _deliveryStatus: self.deliveryStatus.rawValue)
    }
}
