//
//  ChatBubble.swift
//  Ripple
//
//  Created by Abhishek Velekar on 21/12/25.
//

import SwiftUI

struct ChatBubble: Shape {
    let isCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [
            .topLeft, .topRight, isCurrentUser ? .bottomLeft : .bottomRight
        ], cornerRadii: CGSize(width: 16, height: 16))

        return Path(path.cgPath)
    }
    
}

#Preview {
    ChatBubble(isCurrentUser: false)
        .frame(width: 300, height: 100)
}
