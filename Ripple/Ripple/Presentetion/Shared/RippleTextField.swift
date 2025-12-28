//
//  RippleTextField.swift
//  Ripple
//
//  Created by Abhishek Velekar on 20/12/25.
//

import SwiftUI

struct RippleTextField: View {

    @Binding var text: String

    let placeHolder: String

    var body: some View {

        HStack {
            TextField(
                "",
                text: $text,
                prompt: Text(placeHolder).font(
                    Font.custom(FontsConstants.Courier.rawValue, size: 16)
                ).foregroundColor(.gray)
            )
            .foregroundColor(.white)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .init(horizontal: .leading, vertical: .center)
        )
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))

    }
}

#Preview {
    @Previewable @State var text = ""
    ZStack(alignment: .center) {
        Color.darkBg
            .edgesIgnoringSafeArea(.all)

        RippleTextField(
            text: $text, placeHolder: "Enter Name"
        )
        .padding(20)
    }

}
