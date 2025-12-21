//
//  HomeScreen.swift
//  Ripple
//
//  Created by Abhishek Velekar on 20/12/25.
//

import SwiftUI

struct HomeScreen: View {
    
    @State var selectedTab: String = "Chats"
    
    var body: some View {
        ZStack {
            VStack(
                alignment: .trailing
            ) {
                HomeScreenHeader
                
                if selectedTab == "Chats" {
                    InboxScreen()
                }
                else{
                    ActiveUsersScreen()
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )

            FloatingBottomNavBar(
                onSelectionChange: { selectedItem in
                    self.selectedTab = selectedItem
                }
            )
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .bottom
                )
                .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.darkBG)
    }

    var HomeScreenHeader: some View {
        HStack {
            CircularImage(imageName: "WhiteRippleLogo", size: 40)

            Text(selectedTab)
                .font(Font.custom(FontsConstants.Montserrat.rawValue, size: 30))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
    }

}

#Preview {
    NavigationStack {
        HomeScreen()
    }
}
