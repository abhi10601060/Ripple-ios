//
//  TextMessageDomain.swift
//  Ripple
//
//  Created by Abhishek Velekar on 17/12/25.
//

import Foundation

struct TextMessageDomain {
    let id: Int64
    let content: String
    let senderId: String
    let receiverId: String
    let timestamp: Int64
    let deliveryStatus: DeliveryStatus

    init(
        id: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        content: String,
        senderId: String,
        receiverId: String,
        timestamp: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        deliveryStatus: DeliveryStatus = .failed
    ) {
        self.id = id
        self.content = content
        self.senderId = senderId
        self.receiverId = receiverId
        self.timestamp = timestamp
        self.deliveryStatus = deliveryStatus
    }
}

extension TextMessageDomain{
    static let mock = TextMessageDomain(
        content: "Hello How are you?",
        senderId: "123",
        receiverId: "abc"
    )
}
