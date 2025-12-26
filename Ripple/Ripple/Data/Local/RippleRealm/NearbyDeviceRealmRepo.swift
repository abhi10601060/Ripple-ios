//
//  NearbyDeviceRealmRepo.swift
//  Ripple
//
//  Created by Abhishek Velekar on 26/12/25.
//

import Foundation
import RealmSwift
import Combine

final class NearbyDeviceRealmRepo: NearbyDevicePersistenceRepo {
    private let realm: Realm
    private let TAG = "NearbyDeviceRealmRepo"

    init(realm: Realm) {
        self.realm = realm
    }

    func upsertDiscoveredNearbyDevice(_ nearbyDevice: NearbyDevice) async throws {
        print(realm.configuration.fileURL ?? "Didnt found the file url")
        try await realm.asyncWrite {
            if let existingDevice = realm.objects(NearbyDeviceRealm.self).filter("id == %@", nearbyDevice.id).first {
                existingDevice.endpointId = nearbyDevice.endpointId
                existingDevice.deviceName = nearbyDevice.deviceName
                if existingDevice.connectionState != .connected || nearbyDevice.endpointId != existingDevice.endpointId {
                    existingDevice._connectionState = nearbyDevice.connectionState.rawValue
                }
                existingDevice._visibility = DeviceVisibility.online.rawValue
            } else {
                realm.add(nearbyDevice.toNearbyDeviceRealm(), update: .modified)
            }
            print("\(TAG): upsertDiscoveredNearbyDevice: device added successfully")
        }
    }

    func getAllNearbyDevices() -> AnyPublisher<[NearbyDeviceRealm], Never> {
        let allDevices = realm.objects(NearbyDeviceRealm.self)
        return allDevices.collectionPublisher
            .map { result in
                result.filter { device in
                    device.connectionState == .connected || device.recentMessage != nil
                }
            }
            .catch { _ in Just([]) }
            .eraseToAnyPublisher()
    }

    func getAllDiscoveredNearbyDevices() -> AnyPublisher<[NearbyDeviceRealm], Never> {
        let states = [ConnectionState.disconnected, .connected, .discovered].map { $0.rawValue }
        let allDiscoveredDevices = realm.objects(NearbyDeviceRealm.self)
            .filter("_connectionState IN %@", states)
        return allDiscoveredDevices.collectionPublisher
            .map(Array.init)
            .catch { _ in Just([]) }
            .eraseToAnyPublisher()
    }

    func updateConnectionState(endpointId: String, connectionState: ConnectionState) async throws {
        try await realm.asyncWrite {
            if let discoveredDevice = realm.objects(NearbyDeviceRealm.self).filter("endpointId == %@", endpointId).first {
                discoveredDevice._connectionState = connectionState.rawValue
                if connectionState == .lost {
                    discoveredDevice._visibility = DeviceVisibility.offline.rawValue
                }
            }
        }
    }

    func getNearbyDeviceById(_ deviceId: String) -> AnyPublisher<NearbyDeviceRealm?, Never> {
        let device = realm.objects(NearbyDeviceRealm.self).filter("id == %@", deviceId)
        return device.collectionPublisher
            .map { $0.first }
            .catch { _ in Just(nil) }
            .eraseToAnyPublisher()
    }

    func markAllDevicesAsLost() async throws {
        try await realm.asyncWrite {
            let allDevices = realm.objects(NearbyDeviceRealm.self)
            for device in allDevices {
                print("\(TAG): markAllDevicesAsLost: \(device.deviceName) is marked as lost")
                device._connectionState = ConnectionState.lost.rawValue
                device._visibility = DeviceVisibility.offline.rawValue
            }
        }
    }
}

