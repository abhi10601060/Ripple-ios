//
//  SplashScreen.swift
//  Ripple
//
//  Created by Abhishek Velekar on 20/12/25.
//

import SwiftUI

struct SplashScreen: View {
    
    @State private var userName: String = ""
    
    var body: some View {
        ZStack(alignment: .center){
            VStack{
                Image("WhiteRippleLogo")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Text("RIPPLE")
                    .font(Font.custom(FontsConstants.Montserrat.rawValue, size: 40))
                    .foregroundColor(Color.white)
                
                Spacer()
                    .frame(height: 100)
                
                RippleTextField(text: $userName, placeHolder: "Enter User Name...")
            
                
                Text("Note: User name is bound to your device to identify specific devices.")
                    .padding(.top, 4)
                    .font(Font.custom(FontsConstants.Courier.rawValue, size: 16))
                    .foregroundColor(.gray)
                    .lineSpacing(3)
                
                RippleButton(title: "Continue")
                    .padding(.top, 20)
            }
            
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.darkBG)
    }
}

#Preview {
    SplashScreen()
}
