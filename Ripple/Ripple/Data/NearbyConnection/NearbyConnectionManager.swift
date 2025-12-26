//
//  NearbyConnectionManager.swift
//  Ripple
//
//  Created by Abhishek Velekar on 21/11/25.
//


import Foundation
import NearbyConnections
import Combine
import UIKit
import os
import FactoryKit

// MARK: - Models
struct ClusterInfo: Identifiable {
    let id: String
    var devices: [NearbyDevice]
    var isActive: Bool

    init(id: String = UUID().uuidString, devices: [NearbyDevice], isActive: Bool) {
        self.id = id
        self.devices = devices
        self.isActive = isActive
    }
}



// MARK: - NearbyShareManager

@MainActor
class NearbyConnectionManager: NSObject, ObservableObject {
    
    //MARK: - Dependencies
    @Injected(\.nearbyDeviceRealmRepo) var nearbyDevicePersistanceRepo: NearbyDevicePersistenceRepo
    
    // MARK: - Logger

    let logger = Logger(subsystem: "com.app.Ripple", category: "NearbyShareManager")
    
    // MARK: - Singleton
    
    static let shared = NearbyConnectionManager()
    
    // MARK: - Published Properties
    
    @Published private(set) var discoveredDevices: [NearbyDevice] = []
    @Published private(set) var connectedDevices: [NearbyDevice] = []
    @Published private(set) var receivedMessages: [TextMessage] = []
    @Published private(set) var sentMessages: [TextMessage] = []
    @Published private(set) var clusterInfo: ClusterInfo?
    @Published private(set) var isAdvertising: Bool = false
    @Published private(set) var isDiscovering: Bool = false
    
    // MARK: - Private Properties
    
    private var connectionManager: ConnectionManager!
    private var advertiser: Advertiser?
    private var discoverer: Discoverer?
    
    private let serviceId = "com.app.ripple"
    private let deviceName = "Abhi's 17pro:ios:abcdefg"
    private var connectionPool: [EndpointID: String] = [:]
    private var endpointToDeviceID: [EndpointID: String] = [:]
    private var pendingConnectionHandlers: [EndpointID: (Bool) -> Void] = [:]
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
        
        // Initialize connection manager with P2P_CLUSTER strategy
        connectionManager = ConnectionManager(
            serviceID: serviceId,
            strategy: .cluster
        )
        connectionManager.delegate = self
    }
    
    // MARK: - Public API Methods
    
    func startAdvertising() async -> Bool {
        guard advertiser == nil else { return true }
        
        advertiser = Advertiser(connectionManager: connectionManager)
        advertiser?.delegate = self
        
        // Start advertising with device name as endpoint info
        let endpointInfo = deviceName.data(using: .utf8) ?? Data()
        advertiser?.startAdvertising(using: endpointInfo)
        
        isAdvertising = true
        logger.info("Started advertising as: \(self.deviceName)")
        return true
    }
    
    func stopAdvertising() async -> Bool {
        advertiser?.stopAdvertising()
        advertiser = nil
        isAdvertising = false
        
        logger.info("Stopped advertising")
        return true
    }
    
    func startDiscovery() async -> Bool {
        guard discoverer == nil else { return true }
        
        discoverer = Discoverer(connectionManager: connectionManager)
        discoverer?.delegate = self
        discoverer?.startDiscovery()
        
        isDiscovering = true
        logger.info("Started discovery")
        return true
    }
    
    func stopDiscovery() async -> Bool {
        discoverer?.stopDiscovery()
        discoverer = nil
        isDiscovering = false
        
        logger.info("Stopped discovery")
        return true
    }
    
    func connectToDevice(endpointId: String) async -> Bool {
//        guard let endpointId = findEndpointID(for: endpointId) else {
//            logger.debug("Cannot find endpoint for device: \(endpointId) \(endpointId.count)")
//            return false
//        }
        
        updateDeviceConnectionState(endpointId: endpointId, state: .connecting)
        
        // Request connection with device name as context
        let context = deviceName.data(using: .utf8) ?? Data()
        discoverer?.requestConnection(to: endpointId, using: context) { [weak self] accepted in
            Task { @MainActor in
                if (accepted != nil) {
                    self?.logger.info("Connection request accepted for: \(endpointId)")
                    self?.updateDeviceConnectionState(endpointId: endpointId, state: .connected)
                } else {
                    self?.logger.info("Connection request rejected for: \(endpointId)")
                    self?.updateDeviceConnectionState(endpointId: endpointId, state: .disconnected)
                }
            }
        }
        
        logger.debug("Connection requested to: \(endpointId)")
        return true
    }
    
    func disconnectFromDevice(endpointId: String) async -> Bool {
//        guard let endpointId = findEndpointID(for: endpointId) else {
//            return false
//        }
        
        connectionManager.disconnect(from: endpointId)
        updateDeviceConnectionState(endpointId: endpointId, state: .disconnected)
        connectionPool.removeValue(forKey: endpointId)
        endpointToDeviceID.removeValue(forKey: endpointId)
        
        print("Disconnected from: \(endpointId)")
        return true
    }
    
    func sendTextMessage(_ message: TextMessage) async -> Bool {
//        guard let endpointId = findEndpointID(for: message.receiverId) else {
//            var failedMessage = message
//            failedMessage.deliveryStatus = .failed
//            addSentMessage(failedMessage)
//            print("Cannot find endpoint for receiver: \(message.receiverId)")
//            return false
//        }
//        
        do {
            let encoder = JSONEncoder()
            let messageData = try encoder.encode(message.toTextMessageDto())
            print("Sending message to: \(messageData)")
            
            let payloadID = connectionManager.send(messageData, to: [message.endpointId])
            print("Sent payload with ID: \(payloadID)")
            
            var sentMessage = message
            sentMessage.deliveryStatus = .sent
            addSentMessage(sentMessage)
            
            print("Message sent successfully")
            return true
        } catch {
            var failedMessage = message
            failedMessage.deliveryStatus = .failed
            addSentMessage(failedMessage)
            
            print("Error encoding message: \(error.localizedDescription)")
            return false
        }
    }
    
    func createCluster() async -> String {
        let clusterId = UUID().uuidString
        let currentDevice = NearbyDevice(
            id: deviceName,
            endpointId: "abc",
            deviceName: deviceName,
            model: "iPhone 17",
            connectionState: .connected
        )
        
        let cluster = ClusterInfo(
            id: clusterId,
            devices: [currentDevice],
            isActive: true
        )
        
        self.clusterInfo = cluster
        print("Cluster created: \(clusterId)")
        return clusterId
    }
    
    func joinCluster(clusterId: String) async -> Bool {
        let cluster = ClusterInfo(
            id: clusterId,
            devices: connectedDevices,
            isActive: true
        )
        
        self.clusterInfo = cluster
        print("Joined cluster: \(clusterId)")
        return true
    }
    
    func leaveCluster() async -> Bool {
        if var cluster = clusterInfo {
            cluster.isActive = false
            self.clusterInfo = cluster
        }
        
        // Disconnect from all endpoints
        for endpointId in connectionPool.keys {
            connectionManager.disconnect(from: endpointId)
        }
        
        connectionPool.removeAll()
        endpointToDeviceID.removeAll()
        connectedDevices.removeAll()
        
        print("Left cluster")
        return true
    }
    
    // MARK: - Private Helper Methods
    
    private func findEndpointID(for deviceId: String) -> EndpointID? {
        return endpointToDeviceID.first(where: { $0.value == deviceId })?.key
    }
    
    private func addDiscoveredDevice(_ device: NearbyDevice) {
        if let index = discoveredDevices.firstIndex(where: { $0.id == device.id }) {
            discoveredDevices[index] = device
        } else {
            discoveredDevices.append(device)
        }
    }
    
    private func removeDiscoveredDevice(deviceId: String) {
        discoveredDevices.removeAll { $0.id == deviceId }
    }
    
    private func updateDeviceConnectionState(endpointId: String, state: ConnectionState) {
        // Update in discovered devices
        if let index = discoveredDevices.firstIndex(where: { $0.endpointId == endpointId }) {
            discoveredDevices[index].connectionState = state
        }
        
        // Update in realm
        Task{
            try? await nearbyDevicePersistanceRepo.updateConnectionState(endpointId: endpointId, connectionState: state)
        }
        
        // Update connected devices list
        switch state {
        case .connected:
            if let device = discoveredDevices.first(where: { $0.endpointId == endpointId }) {
                if !connectedDevices.contains(where: { $0.endpointId == endpointId }) {
                    var connectedDevice = device
                    connectedDevice.connectionState = state
                    connectedDevices.append(connectedDevice)
                }
            }
            
        case .disconnected:
            connectedDevices.removeAll { $0.endpointId == endpointId }
            
        default:
            if let index = connectedDevices.firstIndex(where: { $0.endpointId == endpointId }) {
                connectedDevices[index].connectionState = state
            }
        }
    }
    
    private func addReceivedMessage(_ message: TextMessage) {
        receivedMessages.append(message)
    }
    
    private func addSentMessage(_ message: TextMessage) {
        sentMessages.append(message)
    }
    
    private func updateMessageDeliveryStatus(receiverId: String, status: DeliveryStatus) {
        for index in sentMessages.indices {
            if sentMessages[index].receiverId == receiverId {
                sentMessages[index].deliveryStatus = status
            }
        }
    }
}

// MARK: - ConnectionManagerDelegate

extension NearbyConnectionManager: ConnectionManagerDelegate {
    
    func connectionManager(_ connectionManager: NearbyConnections.ConnectionManager, didReceiveTransferUpdate update: NearbyConnections.TransferUpdate, from endpointID: NearbyConnections.EndpointID, forPayload payloadID: NearbyConnections.PayloadID) {
        
    }
    
    
    func connectionManager(_ connectionManager: NearbyConnections.ConnectionManager, didChangeTo state: NearbyConnections.ConnectionState, for endpointID: NearbyConnections.EndpointID) {
        Task { @MainActor in
            let deviceId = endpointToDeviceID[endpointID] ?? endpointID.description
            
            switch state {
            case .connected:
                logger.info("Connected to: \(deviceId)")
                connectionPool[endpointID] = deviceId
                updateDeviceConnectionState(endpointId: endpointID, state: .connected)
                
            case .connecting:
                logger.info("Connecting to: \(deviceId)")
                updateDeviceConnectionState(endpointId: endpointID, state: .connecting)
                
            case .disconnected:
                logger.info("Disconnected from: \(deviceId)")
                connectionPool.removeValue(forKey: endpointID)
                endpointToDeviceID.removeValue(forKey: endpointID)
                updateDeviceConnectionState(endpointId: endpointID, state: .disconnected)
                
            case .rejected:
                logger.info("Connection rejected: \(deviceId)")
                updateDeviceConnectionState(endpointId: endpointID, state: .error)
                
//            case .discovered:
//                print("Discovered: \(deviceId)")
//                updateDeviceConnectionState(deviceId: deviceId, state: .discovered)

                
//            case .error:
//                print("Error: \(deviceId)")
           
            @unknown default:
                logger.info("Unknown connection state")
            }
        }
    }
    
    
    nonisolated func connectionManager(
        _ connectionManager: ConnectionManager,
        didReceive verificationCode: String,
        from endpointID: EndpointID,
        verificationHandler: @escaping (Bool) -> Void
    ) {
        Task { @MainActor in
            // Auto-verify connections
            // In production, you should show the verification code to users
            logger.info("Verification code for \(endpointID): \(verificationCode)")
            verificationHandler(true)
        }
    }
    
    nonisolated func connectionManager(
        _ connectionManager: ConnectionManager,
        didReceive data: Data,
        withID payloadID: PayloadID,
        from endpointID: EndpointID
    ) {
        Task { @MainActor in
            do {
                print("json from sender: \(data.description)")
                let decoder = JSONDecoder()
                let messageDto = try decoder.decode(TextMessageDto.self, from: data)
                
                var receivedMessage = TextMessage(content: messageDto.content, senderId: messageDto.senderId, receiverId: messageDto.receiverId)
                receivedMessage.deliveryStatus = .delivered
                
                addReceivedMessage(receivedMessage)
                logger.info("Message received: \(receivedMessage.content)")
            } catch {
                logger.info("Error decoding message: \(error.localizedDescription)")
            }
        }
    }
    
    nonisolated func connectionManager(
        _ connectionManager: ConnectionManager,
        didReceive stream: InputStream,
        withID payloadID: PayloadID,
        from endpointID: EndpointID,
        cancellationToken token: CancellationToken
    ) {
        // Handle stream if needed
        logger.info("Received stream from: \(endpointID)")
    }
    
    nonisolated func connectionManager(
        _ connectionManager: ConnectionManager,
        didStartReceivingResourceWithID payloadID: PayloadID,
        from endpointID: EndpointID,
        at localURL: URL,
        withName name: String,
        cancellationToken token: CancellationToken
    ) {
        // Handle resource receiving
        logger.info("Started receiving resource: \(name) from: \(endpointID)")
    }
    
//    nonisolated func connectionManager(
//        _ connectionManager: ConnectionManager,
//        didReceiveTransferUpdate update: PayloadTransferUpdate,
//        from endpointID: EndpointID,
//        forPayload payloadID: PayloadID
//    ) {
//        Task { @MainActor in
//            switch update.status {
//            case .success:
//                print("Payload transfer successful from: \(endpointID)")
//                if let deviceId = endpointToDeviceID[endpointID] {
//                    updateMessageDeliveryStatus(receiverId: deviceId, status: .delivered)
//                }
//                
//            case .failure:
//                print("Payload transfer failed from: \(endpointID)")
//                if let deviceId = endpointToDeviceID[endpointID] {
//                    updateMessageDeliveryStatus(receiverId: deviceId, status: .failed)
//                }
//                
//            case .inProgress:
//                print("Payload transfer in progress: \(update.fractionCompleted)")
//                
//            case .canceled:
//                print("Payload transfer canceled")
//                
//            @unknown default:
//                print("Unknown payload status")
//            }
//        }
//    }
    
    nonisolated func connectionManager(
        _ connectionManager: ConnectionManager,
        didChangeTo state: ConnectionState,
        for endpointID: EndpointID
    ) {
        Task { @MainActor in
            let deviceId = endpointToDeviceID[endpointID] ?? endpointID.description
            
            switch state {
            case .connected:
                logger.info("Connected to: \(deviceId)")
                connectionPool[endpointID] = deviceId
                updateDeviceConnectionState(endpointId: deviceId, state: .connected)
                
            case .connecting:
                logger.info("Connecting to: \(deviceId)")
                updateDeviceConnectionState(endpointId: deviceId, state: .connecting)
                
            case .disconnected:
                logger.info("Disconnected from: \(deviceId)")
                connectionPool.removeValue(forKey: endpointID)
                endpointToDeviceID.removeValue(forKey: endpointID)
                updateDeviceConnectionState(endpointId: deviceId, state: .disconnected)
                
//            case .rejected:
//                print("Connection rejected: \(deviceId)")
//                updateDeviceConnectionState(deviceId: deviceId, state: .error)
                
            case .discovered:
                logger.info("Discovered: \(deviceId)")
                updateDeviceConnectionState(endpointId: deviceId, state: .discovered)

                
            case .error:
                logger.info("Error: \(deviceId)")
            @unknown default:
                logger.info("Unknown connection state")
            }
        }
    }
}

// MARK: - AdvertiserDelegate

extension NearbyConnectionManager: AdvertiserDelegate {
    
    nonisolated func advertiser(
        _ advertiser: Advertiser,
        didReceiveConnectionRequestFrom endpointID: EndpointID,
        with context: Data,
        connectionRequestHandler: @escaping (Bool) -> Void
    ) {
        Task { @MainActor in
            // Extract device name from context
            let remoteName = String(data: context, encoding: .utf8) ?? endpointID.description
            logger.info("Received connection request from: \(remoteName)")
            
            // Auto-accept connection requests
            // In production, you might want to show a dialog to the user
            connectionRequestHandler(true)
            
            endpointToDeviceID[endpointID] = remoteName
            connectionPool[endpointID] = remoteName
            updateDeviceConnectionState(endpointId: remoteName, state: .connected)

        }
    }
}

// MARK: - DiscovererDelegate

extension NearbyConnectionManager: DiscovererDelegate {
    
    nonisolated func discoverer(
        _ discoverer: Discoverer,
        didFind endpointID: EndpointID,
        with context: Data
    ) {
        Task { @MainActor in
            // Extract device name from endpoint info
            let deviceDescription = String(data: context, encoding: .utf8) ?? endpointID.description
            let descriptionSplits = deviceDescription.split(separator: ":")
            logger.info("Found device: \(deviceDescription)")
            
            let device = NearbyDevice(
                id: String(descriptionSplits[2]),
                endpointId: endpointID,
                deviceName: String(descriptionSplits[0]),
                model: String(descriptionSplits[1]),
                connectionState: .discovered
            )
            
            endpointToDeviceID[endpointID] = device.deviceName
            addDiscoveredDevice(device)
            Task{
                do{
                   try await nearbyDevicePersistanceRepo.upsertDiscoveredNearbyDevice(device)
                }
                catch {
                    print("error saving discoverd deivce to db: \(error.localizedDescription)")
                }
            }
        }
    }
    
    nonisolated func discoverer(
        _ discoverer: Discoverer,
        didLose endpointID: EndpointID
    ) {
        Task { @MainActor in
            let deviceId = endpointToDeviceID[endpointID] ?? endpointID.description
            logger.info("Lost device: \(deviceId)")
            
            removeDiscoveredDevice(deviceId: deviceId)
            endpointToDeviceID.removeValue(forKey: endpointID)
        }
    }
}

