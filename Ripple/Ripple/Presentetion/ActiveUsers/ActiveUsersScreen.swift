//
//  ActiveUsersScreen.swift
//  Ripple
//
//  Created by Abhishek Velekar on 21/12/25.
//

import SwiftUI

struct ActiveUsersScreen: View {
    
    @State var discoveredDevices: [NearbyDeviceDomain] = [NearbyDeviceDomain.mock, NearbyDeviceDomain.mock1, NearbyDeviceDomain.mock2]
    
    var body: some View {
        LazyVStack{
            ForEach(discoveredDevices) { device in
                ActiveUserItem(nearbyDevice: device)
                
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: 0.8)
                    .background(.white)
                    .padding(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    ZStack{
        ActiveUsersScreen()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.darkBG)
}
