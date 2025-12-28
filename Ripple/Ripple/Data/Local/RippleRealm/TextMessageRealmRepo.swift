//
//  TextMessageRealmRepo.swift
//  Ripple
//
//  Created by Abhishek Velekar on 26/12/25.
//

import Foundation
import RealmSwift

@MainActor
final class TextMessageRealmRepo: TextMessagePersistenceRepo {
    private let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }

    func insertSentMessage(_ message: TextMessageRealm) async throws {
        try await realm.asyncWrite {
            if let receiverDevice = realm.objects(NearbyDeviceRealm.self).filter("id == %@", message.receiverId).first {
                receiverDevice.recentMessage = message
                receiverDevice.allMessages.append(message)
            }
        }
    }

    func insertReceivedMessage(_ message: TextMessageRealm) async throws {
        try await realm.asyncWrite {
            if let senderDevice = realm.objects(NearbyDeviceRealm.self).filter("id == %@", message.senderId).first {
                senderDevice.recentMessage = message
                senderDevice.allMessages.append(message)
            }
        }
    }

    func updateDeliveryStatus(id: Int64, status: DeliveryStatus) async throws {
        try await realm.asyncWrite {
            if let savedMessage = realm.objects(TextMessageRealm.self).filter("id == %@", id).first {
                savedMessage._deliveryStatus = status.rawValue
            }
        }
    }
}
