//
//  TextMessage.swift
//  Ripple
//
//  Created by Abhishek Velekar on 17/12/25.
//

import Foundation

struct TextMessage: Identifiable, Codable {
    var id: Int64
    let content: String
    let senderId: String
    let receiverId: String
    let endpointId: String
    let timestamp: Int64
    var deliveryStatus: DeliveryStatus

    init(
        id: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        content: String,
        senderId: String,
        receiverId: String,
        endpointId: String = "null",
        timestamp: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        deliveryStatus: DeliveryStatus = .pending
    ) {
        self.id = id
        self.content = content
        self.senderId = senderId
        self.receiverId = receiverId
        self.endpointId = endpointId
        self.timestamp = timestamp
        self.deliveryStatus = deliveryStatus
    }
}


//struct TextMessage: Identifiable, Codable {
//    let id: String
//    let content: String
//    let senderId: String
//    let receiverId: String
//    var deliveryStatus: DeliveryStatus
//    let timestamp: Date
//
//    init(id: String = UUID().uuidString, content: String, senderId: String, receiverId: String, deliveryStatus: DeliveryStatus, timestamp: Date = Date()) {
//        self.id = id
//        self.content = content
//        self.senderId = senderId
//        self.receiverId = receiverId
//        self.deliveryStatus = deliveryStatus
//        self.timestamp = timestamp
//    }
//}
