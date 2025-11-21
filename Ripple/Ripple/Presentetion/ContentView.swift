//
//  ContentView.swift
//  Ripple
//
//  Created by Abhishek Velekar on 21/11/25.
//

import SwiftUI
import FactoryKit

struct ContentView: View {
    
    @Injected(\.diTestModel) var diTestModel: DiTestModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(diTestModel.text)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
