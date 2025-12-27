//
//  Container.swift
//  Ripple
//
//  Created by Abhishek Velekar on 21/11/25.
//

import Foundation
import FactoryKit
import RealmSwift

extension Container{
    
    @MainActor
    var diTestModel : Factory<DiTestModel>{
        Factory(self) { MainActor.assumeIsolated { DiTestModel() } }
            .singleton
    }
    
    var realm: Factory<Realm>{
        Factory(self) {
            // Define your configuration
            let config = Realm.Configuration(
                schemaVersion: 1,
                objectTypes: [NearbyDeviceRealm.self, TextMessageRealm.self]
            )
            
            return try! Realm(configuration: config)
        }
    }
    
    var nearbyDeviceRealmRepo: Factory<NearbyDevicePersistenceRepo>{
        Factory(self){
            MainActor.assumeIsolated{
                NearbyDeviceRealmRepo(realm: self.realm())
            }
        }
    }
    
    var textMessageRealmRepo: Factory<TextMessagePersistenceRepo>{
        Factory(self){
            MainActor.assumeIsolated{
                TextMessageRealmRepo(realm: self.realm())
            }
        }
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
