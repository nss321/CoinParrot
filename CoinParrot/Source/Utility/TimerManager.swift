//
//  TimerManager.swift
//  CoinParrot
//
//  Created by BAE on 3/9/25.
//

import Foundation
import RxSwift

/// a singleton object managing market list and trend fetch timer.
final class TimerManager {
    static let shared = TimerManager()
    
    private var marketListTimer: DispatchSourceTimer?
    
    private var trendTimer: DispatchSourceTimer?
    
    private init() { }
    
    func startMarketListFetchTimer() {
        marketListTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
        
        marketListTimer?.setEventHandler {
            NetworkManager.shared.fetchMarketData()
            DispatchQueue.global().asyncAfter(deadline: .now()+1) {
                NotificationCenter.default.post(name: Notification.Name("market"), object: nil)
            }
        }

        marketListTimer?.schedule(deadline: .now(), repeating: 5)
        
        marketListTimer?.resume()
    }
    
    func stopMarketListFetchTimer() {
        marketListTimer?.cancel()
        marketListTimer = nil
    }
    
    func startTrendFetchTimer() {
        trendTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
        
        trendTimer?.setEventHandler {
            NetworkManager.shared.fetchTrendingData()
            DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                NotificationCenter.default.post(name: Notification.Name("trend"), object: nil)
            }
        }

        trendTimer?.schedule(deadline: .now(), repeating: 600)
        
        trendTimer?.resume()
    }
    
    func stopTrendFetchTimer() {
        trendTimer?.cancel()
        marketListTimer = nil
    }
    
}
