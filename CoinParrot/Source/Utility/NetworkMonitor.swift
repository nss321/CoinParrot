//
//  NetworkMonitor.swift
//  CoinParrot
//
//  Created by BAE on 3/16/25.
//

import Foundation
import Network

final class NetworkMonitor {
    
    enum ConnectionType{
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    static let shared = NetworkMonitor()
    
    private lazy var queue = DispatchQueue.global()
    
    private lazy var monitor = NWPathMonitor()
    
    private(set) lazy var isConnected: Bool = false
    
    private(set) lazy var connectionType: ConnectionType = .unknown
    
    
    private init() { }
    
    public func startMonitoring(){
        
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { [weak self] path in
            
            self?.isConnected = path.status == .satisfied
            
            self?.getConnectionType(path)
            
            if self?.isConnected == true{
                print("네트워크연결됨")
            } else {
                print("네트워크 연결 오류")
            }
        }
    }
    
    public func stopMonitoring(){
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath){
        
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular){
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet){
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
        
    }
    
    
}
