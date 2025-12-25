//
//  TextMessageDomain.swift
//  Ripple
//
//  Created by Abhishek Velekar on 17/12/25.
//

import Foundation

struct TextMessageDomain: Identifiable, Hashable {
    let id: Int64
    let content: String
    let senderId: String
    let receiverId: String
    let endpointId: String
    let timestamp: Int64
    let deliveryStatus: DeliveryStatus

    init(
        id: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        content: String,
        senderId: String,
        receiverId: String,
        endpointId: String,
        timestamp: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        deliveryStatus: DeliveryStatus = .failed
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

extension TextMessage{
    func toTextMessageDomain() -> TextMessageDomain {
       return  TextMessageDomain(
            id: self.id,
            content: self.content,
            senderId: self.senderId,
            receiverId: self.receiverId,
            endpointId: self.endpointId,
            timestamp: self.timestamp,
            deliveryStatus: self.deliveryStatus)
    }
}

extension TextMessageDomain{
    static let mock = TextMessageDomain(
        id: 1,
        content: "Hello How are you?",
        senderId: "123",
        receiverId: "abc",
        endpointId: "abc"
    )
    
    static let mock1 = TextMessageDomain(
        id: 2,
        content: "Excellent, How are you...All good...?",
        senderId: "456",
        receiverId: "abc",
        endpointId: "abc"

    )
    
    static let mock2 = TextMessageDomain(
        id: 3,
        content: "yes",
        senderId: "123",
        receiverId: "abc",
        endpointId: "abc"
    )
    
    static let mock3 = TextMessageDomain(
        id: 4,
        content: "nice nice",
        senderId: "456",
        receiverId: "abc",
        endpointId: "abc"
    )
}
