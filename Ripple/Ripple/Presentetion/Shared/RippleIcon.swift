//
//  RippleIcon.swift
//  Ripple
//
//  Created by Abhishek Velekar on 20/12/25.
//

import SwiftUI

struct RippleIcon: View {
    
    var size: CGFloat = 25
    var iconName: String = "magnifyingglass"
    
    var body: some View {
        ZStack {
            
            Circle()
                .fill(.secondaryDarkBG)
                .frame(width: size * 2, height: size * 2)
            
            Circle()
                .fill(.tertiaryDarkBG)
                .frame(width: size * 1.5, height: size * 1.5)

            
            Circle()
                .fill(.white)
                .frame(width: size * 1.1, height: size * 1.1)

            
            Image(systemName: iconName)
                .fixedSize()
                .frame(width: size, height: size)
                
        }
    }
}

#Preview {
    ZStack {
        RippleIcon(
            size: 25, iconName: "paperplane.fill"
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.darkBG)

}
