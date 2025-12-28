//
//  DeliveryStatus.swift
//  Ripple
//
//  Created by Abhishek Velekar on 17/12/25.
//

import Foundation
import RealmSwift


enum DeliveryStatus: String, Codable, PersistableEnum {
    case pending
    case sent
    case delivered
    case failed
}
