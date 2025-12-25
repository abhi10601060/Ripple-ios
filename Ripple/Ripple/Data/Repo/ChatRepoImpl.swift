//
//  ChatRepoImpl.swift
//  Ripple
//
//  Created by Abhishek Velekar on 25/12/25.
//

import Combine

class ChatRepoImpl: ChatRepo {
    
    let nearbyShareManager: NearbyConnectionManager
    
    init(nearbyShareManager: NearbyConnectionManager) {
        self.nearbyShareManager = nearbyShareManager
    }
    
    func sendTextMessage(message: TextMessage) async -> Bool {
        return await nearbyShareManager.sendTextMessage(message)
    }
    
    func getAllMessages(userId: String) -> AnyPublisher<[TextMessage], Never> {
        return Publishers.CombineLatest(nearbyShareManager.$receivedMessages, nearbyShareManager.$sentMessages)
            .filter{ receivedMessages, sentMessages in
                receivedMessages.contains(where: { $0.receiverId == userId || $0.senderId == userId }) || sentMessages.contains(where: { $0.receiverId == userId || $0.senderId == userId })
            }
            .map{  receivedMessages, sentMessages in
                receivedMessages + sentMessages
            }
            .eraseToAnyPublisher()
        
//        return nearbyShareManager.$sentMessages.eraseToAnyPublisher()
    }
    
    
}
