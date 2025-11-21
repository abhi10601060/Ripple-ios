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
    
}
