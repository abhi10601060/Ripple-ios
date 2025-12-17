//
//  DeliveryStatus.swift
//  Ripple
//
//  Created by Abhishek Velekar on 17/12/25.
//

import Foundation


enum DeliveryStatus: String, Codable {
    case pending
    case sent
    case delivered
    case failed
}
