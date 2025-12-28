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
    @State private var navigationPath: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath){
            SplashScreen(
                navigationPath: $navigationPath
            )
            .navigationDestination(for: String.self, destination: {
                string in
                HomeScreen(
                    navigationPath: $navigationPath
                )
            })
            .navigationDestination(for: NearbyDeviceDomain.self, destination: { device in
                ChatScreen(
                    nearbyDevice: device
                )
            })
        }
    }
}

#Preview {
    ContentView()
}
