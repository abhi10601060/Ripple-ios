//
//  ChatScreen.swift
//  Ripple
//
//  Created by Abhishek Velekar on 21/12/25.
//

import SwiftUI

struct ChatScreen: View {

    let nearbyDevice: NearbyDeviceDomain
    private let scrollId = "scrollToBottom"
    @StateObject private var chatScreenViewModel: ChatScreenViewModel = ChatScreenViewModel()


    @State var messageText: String = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            VStack {
                ChatScreenHeader
                
                ScrollView {
                    ScrollViewReader { proxy in
                        LazyVStack {
                            ForEach(chatScreenViewModel.currentNearbyDeviceDomain?.allMessages ?? []) { message in
                                ChatTextMessage(
                                    message: message,
                                    isFromCurretUser: message.receiverId
                                        == nearbyDevice.id
                                )
                            }
                            .id(scrollId)
                        }
                        .onChange(of: nearbyDevice.allMessages.count) {
                            oldValue,
                            newValue in
                            // Scroll to the bottom when messages change
                            withAnimation {
                                proxy.scrollTo(scrollId, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if chatScreenViewModel.currentNearbyDeviceDomain?.visibility == .offline {
                Text("Device offline. Cannot connect...")
                    .font(Font.custom(FontsConstants.Courier.rawValue, size: 16))
                    .foregroundColor(.gray)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .center
                    )
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .padding(.horizontal, 10)

            }
            else if chatScreenViewModel.currentNearbyDeviceDomain?.connectionState == .connected {
                ChatBox
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .bottom
                    )
                    .padding(.horizontal, 10)            }
            else {
                Text("Tap to connect...")
                    .font(Font.custom(FontsConstants.Courier.rawValue, size: 16))
                    .foregroundColor(.gray)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .center
                    )
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        chatScreenViewModel.connectToCurrentNearbyDevice()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .padding(.horizontal, 10)
            }

            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.darkBG)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear{
            chatScreenViewModel.assignCurrentDevice(currentNearbyDevice: nearbyDevice)
        }
    }

    var ChatScreenHeader: some View {
        HStack {
            
            RippleIcon(
                size: 20,
                iconName: "chevron.left"
            )
            .onTapGesture {
                dismiss()
            }

            CircularImage(imageName: "", size: 40)

            Text(nearbyDevice.deviceName)
                .font(Font.custom(FontsConstants.Montserrat.rawValue, size: 20))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var ChatBox: some View {
        HStack {
            RippleTextField(
                text: $messageText,
                placeHolder: "Enter message here..."
            )
            .frame(maxWidth: .infinity)

            RippleIcon(
                size: 23,
                iconName: "paperplane.fill"
            )
            .onTapGesture {
                chatScreenViewModel.sendMessage(messageText)
                messageText = ""
            }
        }
    }
}

#Preview {
    ChatScreen(
        nearbyDevice: NearbyDeviceDomain.mock
    )
}
