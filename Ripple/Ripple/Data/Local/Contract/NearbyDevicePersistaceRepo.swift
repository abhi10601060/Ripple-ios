//
//  NearbyDevicePersistaceRepo.swift
//  Ripple
//
//  Created by Abhishek Velekar on 26/12/25.
//

import Foundation

import Combine

protocol NearbyDevicePersistenceRepo {
    // Insert or update a discovered device
    func upsertDiscoveredNearbyDevice(_ nearbyDevice: NearbyDevice) async throws

    // All nearby devices stream
    func getAllNearbyDevices() -> AnyPublisher<[NearbyDeviceRealm], Never>

    // Only discovered devices stream
    func getAllDiscoveredNearbyDevices() -> AnyPublisher<[NearbyDeviceRealm], Never>

    // Update a connection state for a device by endpoint ID
    func updateConnectionState(endpointId: String, connectionState: ConnectionState) async throws

    // Get single device by ID stream
    func getNearbyDeviceById(_ deviceId: String) -> AnyPublisher<NearbyDeviceRealm?, Never>

    // Mark all devices as lost
    func markAllDevicesAsLost() async throws
}
