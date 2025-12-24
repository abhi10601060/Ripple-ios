//
//  ActiveUserItem.swift
//  Ripple
//
//  Created by Abhishek Velekar on 21/12/25.
//

import SwiftUI

struct ActiveUserItem: View {
    
    @ObservedObject var homeScreenViewModel: HomeScreenViewModel
    let nearbyDevice: NearbyDeviceDomain
    
    var body: some View {
        HStack(
            alignment: .top
        ){
            CircularImage(imageName: "person", size: 50)
            
            VStack(
                alignment: .leading
            ){
                Text(nearbyDevice.deviceName)
                    .font(
                        .custom(FontsConstants.Courier.rawValue, size: 18)
                    )
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Spacer()
                    .frame(height: 10)
                
                Text("~\(nearbyDevice.model)")
                    .font(
                        .custom(FontsConstants.Courier.rawValue, size: 15)
                    )
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 4)
            
            
            Text(nearbyDevice.connectionState == .connected ?  "Disconnect" : "Connect")
                .font(
                    .custom(FontsConstants.Courier.rawValue, size: 12)
                )
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background{
                    Capsule()
                        .fill(.secondaryDarkBG)
                }
                .padding(.top, 8)
                .onTapGesture {
                    if self.nearbyDevice.connectionState == .connected {
                        homeScreenViewModel.disconnectFromNearbyDevice(device: self.nearbyDevice)
                    }
                    else{
                        homeScreenViewModel.connectToNearbyDevice(device: self.nearbyDevice)
                    }
                }
                
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ZStack{
        ActiveUserItem(
            homeScreenViewModel: HomeScreenViewModel(),
            nearbyDevice: NearbyDeviceDomain.mock
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.darkBG)
}
