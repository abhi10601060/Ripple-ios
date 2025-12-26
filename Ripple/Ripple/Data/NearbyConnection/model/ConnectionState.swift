//
//  ConnectionState.swift
//  Ripple
//
//  Created by Abhishek Velekar on 17/12/25.
//

import Foundation
import RealmSwift


enum ConnectionState: String, Codable, PersistableEnum {
    case discovered
    case connecting
    case connected
    case disconnected
    case error
    case sending
    case receiving
    case lost
}
