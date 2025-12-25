//
//  ChatRepo.swift
//  Ripple
//
//  Created by Abhishek Velekar on 25/12/25.
//

import Combine

protocol ChatRepo {
    func sendTextMessage(message: TextMessage) async -> Bool
    
    func getAllMessages(userId: String) -> AnyPublisher<[TextMessage], Never>
}
