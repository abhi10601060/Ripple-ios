//
//  ChatTextMessage.swift
//  Ripple
//
//  Created by Abhishek Velekar on 21/12/25.
//

import SwiftUI

struct ChatTextMessage: View {
    let message: TextMessageDomain
    let isFromCurretUser: Bool
    
    @State private var hWidth: Double = 110

    var body: some View {

        HStack(alignment: .center) {
            if !isFromCurretUser {
                CircularImage(imageName: "", size: 24)
            }

            Text(message.content)
                .padding(10)
                .background(isFromCurretUser ? .white : .secondaryDarkBG)
                .clipShape(ChatBubble(isCurrentUser: isFromCurretUser))
                .frame(maxWidth: hWidth * 0.6, alignment: isFromCurretUser ? .trailing : .leading)
                .padding(.trailing, 8)
                .font(.subheadline)
                .foregroundColor(isFromCurretUser ? .black : .white)
                
        }
        .frame(
            maxWidth: .infinity,
            alignment: isFromCurretUser ? .trailing : .leading
        )
        .overlay {
            // To get the parent view size
            GeometryReader { proxy in
                Text("")
                    .onAppear {
                        hWidth = proxy.frame(in: .global).width
                    }
                    .onChange(of: proxy.frame(in: .global), initial: false) {
                        oldValue,
                        newValue in
                        hWidth = newValue.width
                    }
            }
        }

    }
}

#Preview {
    ZStack{
        ChatTextMessage(
            message: TextMessageDomain.mock, isFromCurretUser: false
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.darkBg)
    
}
