//
//  SendTextMessageUseCase.swift
//  Ripple
//
//  Created by Abhishek Velekar on 25/12/25.
//

import Foundation
import FactoryKit

struct SendTextMessageUseCase {
    
    @Injected(\.chatRepo) var chatrepo: ChatRepo
    
    func invoke(message: TextMessageDomain) async -> Bool{
        return await chatrepo.sendTextMessage(message: message.toTextMessage())
    }
}
