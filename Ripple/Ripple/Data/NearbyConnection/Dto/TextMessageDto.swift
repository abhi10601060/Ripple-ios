//
//  TextMessageDto.swift
//  Ripple
//
//  Created by Abhishek Velekar on 25/12/25.
//

import Foundation

struct TextMessageDto: Codable {
    let content: String
    let senderId: String
    let receiverId: String
}

extension TextMessage{
    func toTextMessageDto() -> TextMessageDto{
        TextMessageDto(content: self.content, senderId: self.senderId, receiverId: self.receiverId)
    }
}
