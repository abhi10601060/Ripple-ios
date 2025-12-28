//
//  RippleApp.swift
//  Ripple
//
//  Created by Abhishek Velekar on 21/11/25.
//

import SwiftUI

@main
struct RippleApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    private let markAllDevicesLostUseCase = MarkAllNearbyDeviceLostUseCase()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                // This runs when the app goes to the background (not terminated)
                print("App is going to the background")
                Task{
//                    DispatchQueue.main.async{
                        await markAllDevicesLostUseCase.invoke()
//                    }
                }
            }
        }
    }
}
