//
//  FloatingBottomNavBar.swift
//  Ripple
//
//  Created by Abhishek Velekar on 20/12/25.
//

import SwiftUI

struct FloatingBottomNavBar: View {
    
    @State var selectedItem: String = "Chats"
    var onSelectionChange: (String) -> Void = {_ in }
    
    var body: some View {
        HStack(
            alignment: .center
        ) {
            FloatingNavBarItem(
                icon: "bubble.left.and.bubble.right.fill", 
                title: "Chats",
                isSelected: selectedItem == "Chats"
            )
            .onTapGesture {
                selectedItem = "Chats"
                onSelectionChange("Chats")
            }
            .padding(.horizontal, 20)
            
            Spacer()
                .frame(width: 1, height: 40)
                .background(.gray)
            
            
            FloatingNavBarItem(
                icon: "person.3.fill",
                title: "Actives",
                isSelected: selectedItem == "Actives"
            )
            .onTapGesture {
                selectedItem = "Actives"
                onSelectionChange("Actives")
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 65)
        .background(.secondaryDarkBG)
        .clipShape(RoundedRectangle(cornerRadius: 35))
        .shadow(color: .gray, radius: 9, x:0, y: 8)
    }

}

struct FloatingNavBarItem: View {
    
    let icon: String
    let title: String
    var isSelected: Bool = false
    
    var body: some View {
        VStack {
            Image(
                systemName: icon,
            )
            .foregroundColor(isSelected ? .white : .gray)
            .fixedSize()

            Spacer()
                .frame(height: 5)

            Text(title)
                .font(.custom(FontsConstants.Courier.rawValue, size: 15))
                .foregroundColor(isSelected ? .white : .gray)
        }
        .scaleEffect(isSelected ? 1.2 : 1)
        .padding(10)
        .frame(maxWidth: 100)
    }
}

#Preview {
    ZStack {
        FloatingBottomNavBar()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.darkBG)
}
