//
//  InboxScreen.swift
//  Ripple
//
//  Created by Abhishek Velekar on 20/12/25.
//

import SwiftUI

struct InboxScreen: View {
    
    @Binding var navigationPath: NavigationPath
    @State var searchText: String = ""
    @State var connectedDevices: [NearbyDeviceDomain] = [NearbyDeviceDomain.mock, NearbyDeviceDomain.mock1, NearbyDeviceDomain.mock2]
    
    var body: some View {
        VStack(
            alignment: .leading
        ) {
            SearchBox
            
            LazyVStack{
                ForEach(connectedDevices){ device in
                    
                    InboxItem(nearbyDevice: device)
                        .onTapGesture {
                            navigationPath.append(device)
                        }
                    
                    
                    Spacer()
                        .padding(10)
                        .frame(maxWidth: .infinity, maxHeight: 0.8)
                        .background(.white)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.darkBG)
    }
    
    var SearchBox: some View {
        HStack(
            alignment: .center
        ) {
            RippleIcon(
                size: 24,
                iconName: "magnifyingglass"
            )
            
            RippleTextField(text: $searchText, placeHolder: "Enter Text Here...")
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    @Previewable @State var navpath = NavigationPath()
    NavigationStack(path: $navpath) {
        InboxScreen(
            navigationPath: $navpath
        )
    }
}
