//
//  GetAllMessagesUseCase.swift
//  Ripple
//
//  Created by Abhishek Velekar on 25/12/25.
//

import Foundation
import FactoryKit
import Combine

struct GetAllMessagesUseCase {
    
    @Injected(\.chatRepo) var chatrepo: ChatRepo
    
    func invoke(userId: String) -> AnyPublisher<[TextMessageDomain], Never> {
        return chatrepo.getAllMessages(userId: userId)
            .map{
                messages in
                messages.map{
                    message in
                    message.toTextMessageDomain()
                }
            }.eraseToAnyPublisher()
    }
}
