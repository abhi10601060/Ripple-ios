//
//  ActiveUsersScreen.swift
//  Ripple
//
//  Created by Abhishek Velekar on 21/12/25.
//

import SwiftUI

struct ActiveUsersScreen: View {
    
    @ObservedObject var viewModel: HomeScreenViewModel
    @State var discoveredDevices: [NearbyDeviceDomain] = [NearbyDeviceDomain.mock, NearbyDeviceDomain.mock1, NearbyDeviceDomain.mock2]
    
    var body: some View {
        LazyVStack{
            ForEach(viewModel.discoveredDevices) { device in
                ActiveUserItem(homeScreenViewModel: viewModel, nearbyDevice: device)
                
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
        ActiveUsersScreen(viewModel: HomeScreenViewModel())
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.darkBg)
}
