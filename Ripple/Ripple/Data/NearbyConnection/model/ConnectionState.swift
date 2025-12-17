//
//  ConnectionState.swift
//  Ripple
//
//  Created by Abhishek Velekar on 17/12/25.
//

import Foundation


enum ConnectionState: String, Codable {
    case discovered
    case connecting
    case connected
    case disconnected
    case error
    case sending
    case receiving
    case lost
}
