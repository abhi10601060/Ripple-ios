//
//  RippleButton.swift
//  Ripple
//
//  Created by Abhishek Velekar on 20/12/25.
//

import SwiftUI

struct RippleButton: View {
    let title: String
    
    var body: some View {
        VStack{
            Text(title)
                .font(Font.custom(FontsConstants.Courier.rawValue, size: 14))
        }
        .fixedSize()
        .padding(12)
        .padding(.horizontal, 15)
        .background{
            Color.white
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    VStack{
        RippleButton(title: "Continue")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.darkBg)
    
}
