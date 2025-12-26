//
//  TextMessagePersistanceRepo.swift
//  Ripple
//
//  Created by Abhishek Velekar on 26/12/25.
//

import Foundation

protocol TextMessagePersistenceRepo {
    func insertSentMessage(_ message: TextMessageRealm) async throws
    func insertReceivedMessage(_ message: TextMessageRealm) async throws
    func updateDeliveryStatus(id: Int64, status: DeliveryStatus) async throws
}

