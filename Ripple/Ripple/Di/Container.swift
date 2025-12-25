//
//  Container.swift
//  Ripple
//
//  Created by Abhishek Velekar on 21/11/25.
//

import Foundation
import FactoryKit

extension Container{
    
    @MainActor
    var diTestModel : Factory<DiTestModel>{
        Factory(self) { MainActor.assumeIsolated { DiTestModel() } }
            .singleton
    }
    
    var nerbyConnectionManager: Factory<NearbyConnectionManager>{
        Factory(self) { MainActor.assumeIsolated { NearbyConnectionManager.shared } }
            .singleton
    }
    
    var nearbyConnectionRepo: Factory<NearbyConnectionRepo>{
        Factory(self){
            MainActor.assumeIsolated{
                NearbyConnectionRepoImpl(nearbyShareManager: self.nerbyConnectionManager())
            }
        }.singleton
    }
    
    var chatRepo: Factory<ChatRepo>{
        Factory(self){
            MainActor.assumeIsolated {
                ChatRepoImpl(nearbyShareManager:  self.nerbyConnectionManager())
            }
        }
    }
}
