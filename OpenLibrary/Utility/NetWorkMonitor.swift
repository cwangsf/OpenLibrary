//
//  NetWorkManager.swift
//  iOSTechTest
//
//  Created by Cynthia Wang on 4/24/25.
//

import SwiftUI
import Network
import Observation

extension EnvironmentValues {
    @Entry var isNetworkConnected: Bool?
}

class NetworkMonitor: ObservableObject {
    @Published var isConnected: Bool = true
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor [weak self] in
                let isConnected = path.status == .satisfied
                self?.isConnected = isConnected
                
                #if DEBUG
                let status = """
                    Network Status:
                    - Connected: \(isConnected)
                    - Path status: \(path.status)
                    - Interfaces: \(path.availableInterfaces.map { $0.type })
                    - Using cellular: \(path.usesInterfaceType(.cellular))
                    - Using WiFi: \(path.usesInterfaceType(.wifi))
                    - Is constrained: \(path.isConstrained)
                    - Is expensive: \(path.isExpensive)
                    """
                print(status)
                #endif
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}
