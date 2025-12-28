//
//  InboxItem.swift
//  Ripple
//
//  Created by Abhishek Velekar on 21/12/25.
//

import SwiftUI

struct InboxItem: View {

    let nearbyDevice: NearbyDeviceDomain

    var body: some View {
        HStack(alignment: .top) {
            InboxItemProfileImageSection

            VStack {
                HStack(
                    alignment: .top,
                    spacing: 2
                ) {
                    Text(nearbyDevice.deviceName)
                        .font(
                            .custom(FontsConstants.Courier.rawValue, size: 18)
                        )
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Spacer()

                    Text(formatTimestamp(timestamp: nearbyDevice.lastSeen))
                        .font(
                            .custom(FontsConstants.Courier.rawValue, size: 12)
                        )
                        .foregroundColor(.gray)

                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 5, height: 8, alignment: .center)
                        .padding(.top, 2)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 5)

                Text(
                    nearbyDevice.recentMessage?.content
                        ?? "Start Conversation..."
                )
                .padding(.top, 3)
                .font(.custom(FontsConstants.Courier.rawValue, size: 15))
                .foregroundColor(.gray)
                .frame(
                    maxWidth: .infinity,
                    alignment: .init(horizontal: .leading, vertical: .top)
                )
                .lineLimit(2)
                .truncationMode(.tail)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var InboxItemProfileImageSection: some View {
        VStack(
            alignment: .center,
            spacing: 8
        ) {
            CircularImage(imageName: "person.crop.circle", size: 50)

            HStack(
                spacing: 4
            ) {
                Image(
                    systemName: nearbyDevice.visibility == .online
                        ? "checkmark.circle.fill" : "xmark.circle.fill"
                )
                .resizable()
                .frame(width: 10, height: 10)
                .foregroundColor(.white)

                Text(nearbyDevice.visibility == .online ? "Online" : "Offline")
                    .font(.custom(FontsConstants.Courier.rawValue, size: 10))
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    ZStack {
        InboxItem(
            nearbyDevice: NearbyDeviceDomain.mock
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.darkBg)
}
