//
//  NearbyShareView.swift
//  Ripple
//
//  Created by Abhishek Velekar on 21/11/25.
//

import SwiftUI

struct NearbyShareView: View {
    @StateObject private var manager = NearbyConnectionManager.shared
    @State private var messageText = ""
    @State private var selectedDeviceId: String?
    @State private var showingMessageSheet = false
    @State private var statusMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Status Section
                    statusSection
                    
                    // Control Buttons
                    controlButtons
                    
                    // Discovered Devices
                    discoveredDevicesSection
                    
                    // Connected Devices
                    connectedDevicesSection
                    
                    // Messages Section
                    messagesSection
                    
                    // Cluster Section
                    clusterSection
                }
                .padding()
            }
            .navigationTitle("Nearby Share")
            .sheet(isPresented: $showingMessageSheet) {
                messageInputSheet
            }
        }
    }
    
    // MARK: - Status Section
    
    private var statusSection: some View {
        VStack(spacing: 12) {
            HStack {
                Circle()
                    .fill(manager.isAdvertising ? Color.green : Color.gray)
                    .frame(width: 10, height: 10)
                Text("Advertising: \(manager.isAdvertising ? "ON" : "OFF")")
                    .font(.subheadline)
                Spacer()
            }
            
            HStack {
                Circle()
                    .fill(manager.isDiscovering ? Color.blue : Color.gray)
                    .frame(width: 10, height: 10)
                Text("Discovering: \(manager.isDiscovering ? "ON" : "OFF")")
                    .font(.subheadline)
                Spacer()
            }
            
            if !statusMessage.isEmpty {
                Text(statusMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Control Buttons
    
    private var controlButtons: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button {
                    Task {
                        if manager.isAdvertising {
                            await manager.stopAdvertising()
                            await manager.stopDiscovery()
                            statusMessage = "Stopped advertising"
                        } else {
                            let success = await manager.startAdvertising()
                            let s = await manager.startDiscovery()
                            statusMessage = success ? "Started advertising" : "Failed to advertise"
                        }
                    }
                } label: {
                    Label(
                        manager.isAdvertising ? "Stop Advertising" : "Start Advertising",
                        systemImage: manager.isAdvertising ? "antenna.radiowaves.left.and.right.slash" : "antenna.radiowaves.left.and.right"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(manager.isAdvertising ? .red : .green)
                
                Button {
                    Task {
                        if manager.isDiscovering {
                            await manager.stopDiscovery()
                            statusMessage = "Stopped discovery"
                        } else {
                            let success = await manager.startDiscovery()
                            statusMessage = success ? "Started discovery" : "Failed to discover"
                        }
                    }
                } label: {
                    Label(
                        manager.isDiscovering ? "Stop Discovery" : "Start Discovery",
                        systemImage: manager.isDiscovering ? "magnifyingglass.circle.fill" : "magnifyingglass.circle"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(manager.isDiscovering ? .red : .blue)
            }
        }
    }
    
    // MARK: - Discovered Devices Section
    
    private var discoveredDevicesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Discovered Devices (\(manager.discoveredDevices.count))")
                .font(.headline)
            
            if manager.discoveredDevices.isEmpty {
                Text("No devices found. Start discovery to find nearby devices.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            } else {
                ForEach(manager.discoveredDevices) { device in
                    DeviceRow(device: device) {
                        Task {
                            let success = await manager.connectToDevice(deviceId: device.id)
                            statusMessage = success ? "Connecting to \(device.deviceName)..." : "Failed to connect"
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Connected Devices Section
    
    private var connectedDevicesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Connected Devices (\(manager.connectedDevices.count))")
                .font(.headline)
            
            if manager.connectedDevices.isEmpty {
                Text("No connected devices")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            } else {
                ForEach(manager.connectedDevices) { device in
                    ConnectedDeviceRow(device: device, onSendMessage: {
                        selectedDeviceId = device.id
                        showingMessageSheet = true
                    }, onDisconnect: {
                        Task {
                            await manager.disconnectFromDevice(deviceId: device.id)
                            statusMessage = "Disconnected from \(device.deviceName)"
                        }
                    })
                }
            }
        }
    }
    
    // MARK: - Messages Section
    
    private var messagesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Messages")
                .font(.headline)
            
            // Received Messages
            if !manager.receivedMessages.isEmpty {
                Text("Received (\(manager.receivedMessages.count))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ForEach(manager.receivedMessages.suffix(5)) { message in
                    MessageRow(message: message, isReceived: true)
                }
            }
            
            // Sent Messages
            if !manager.sentMessages.isEmpty {
                Text("Sent (\(manager.sentMessages.count))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
                
                ForEach(manager.sentMessages.suffix(5)) { message in
                    MessageRow(message: message, isReceived: false)
                }
            }
            
            if manager.receivedMessages.isEmpty && manager.sentMessages.isEmpty {
                Text("No messages yet")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
        }
    }
    
    // MARK: - Cluster Section
    
    private var clusterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cluster")
                .font(.headline)
            
            if let cluster = manager.clusterInfo {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("ID: \(cluster.id.prefix(8))...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Circle()
                            .fill(cluster.isActive ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        Text(cluster.isActive ? "Active" : "Inactive")
                            .font(.caption)
                    }
                    
                    Text("Devices: \(cluster.devices.count)")
                        .font(.caption)
                    
                    Button {
                        Task {
                            await manager.leaveCluster()
                            statusMessage = "Left cluster"
                        }
                    } label: {
                        Label("Leave Cluster", systemImage: "xmark.circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            } else {
                HStack(spacing: 12) {
                    Button {
                        Task {
                            let clusterId = await manager.createCluster()
                            statusMessage = "Created cluster: \(clusterId.prefix(8))..."
                        }
                    } label: {
                        Label("Create Cluster", systemImage: "plus.circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    
                    Button {
                        Task {
                            let success = await manager.joinCluster(clusterId: "demo-cluster")
                            statusMessage = success ? "Joined cluster" : "Failed to join"
                        }
                    } label: {
                        Label("Join Cluster", systemImage: "person.2")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
    
    // MARK: - Message Input Sheet
    
    private var messageInputSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Send Message")
                    .font(.headline)
                
                if let deviceId = selectedDeviceId,
                   let device = manager.connectedDevices.first(where: { $0.id == deviceId }) {
                    Text("To: \(device.deviceName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                TextEditor(text: $messageText)
                    .frame(height: 150)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                Button {
                    Task {
                        guard let deviceId = selectedDeviceId, !messageText.isEmpty else { return }
                        
                        let message = TextMessage(
                            content: messageText,
                            senderId: UIDevice.current.name,
                            receiverId: deviceId,
                            deliveryStatus: .pending
                        )
                        
                        let success = await manager.sendTextMessage(message)
                        statusMessage = success ? "Message sent" : "Failed to send message"
                        
                        messageText = ""
                        showingMessageSheet = false
                    }
                } label: {
                    Label("Send", systemImage: "paperplane.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(messageText.isEmpty)
                
                Spacer()
            }
            .padding()
            .navigationBarItems(trailing: Button("Cancel") {
                showingMessageSheet = false
                messageText = ""
            })
        }
    }
}

// MARK: - Device Row

struct DeviceRow: View {
    let device: NearbyDevice
    let onConnect: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "iphone")
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(device.deviceName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(device.connectionState.rawValue.capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if device.connectionState == .discovered {
                Button(action: onConnect) {
                    Text("Connect")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.bordered)
            } else {
                Image(systemName: connectionStateIcon(device.connectionState))
                    .foregroundColor(connectionStateColor(device.connectionState))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    private func connectionStateIcon(_ state: ConnectionState) -> String {
        switch state {
        case .connecting: return "antenna.radiowaves.left.and.right"
        case .connected: return "checkmark.circle.fill"
        case .error: return "exclamationmark.triangle.fill"
        default: return "circle"
        }
    }
    
    private func connectionStateColor(_ state: ConnectionState) -> Color {
        switch state {
        case .connecting: return .blue
        case .connected: return .green
        case .error: return .red
        default: return .gray
        }
    }
}

// MARK: - Connected Device Row

struct ConnectedDeviceRow: View {
    let device: NearbyDevice
    let onSendMessage: () -> Void
    let onDisconnect: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "iphone")
                .foregroundColor(.green)
            
            Text(device.deviceName)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            Button(action: onSendMessage) {
                Image(systemName: "message.fill")
            }
            .buttonStyle(.bordered)
            
            Button(action: onDisconnect) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// MARK: - Message Row

struct MessageRow: View {
    let message: TextMessage
    let isReceived: Bool
    
    var body: some View {
        VStack(alignment: isReceived ? .leading : .trailing, spacing: 4) {
            Text(message.content)
                .font(.subheadline)
                .padding(10)
                .background(isReceived ? Color.blue.opacity(0.2) : Color.green.opacity(0.2))
                .cornerRadius(8)
            
            HStack(spacing: 4) {
                Text(isReceived ? "From: \(message.senderId)" : "To: \(message.receiverId)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                deliveryStatusIcon
            }
        }
        .frame(maxWidth: .infinity, alignment: isReceived ? .leading : .trailing)
    }
    
    private var deliveryStatusIcon: some View {
        Group {
            switch message.deliveryStatus {
            case .pending:
                Image(systemName: "clock")
                    .foregroundColor(.orange)
            case .sent:
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            case .delivered:
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            case .failed:
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .font(.caption2)
    }
}

// MARK: - Preview

#Preview {
    NearbyShareView()
}
