//
//  Sort.swift
//  CoinParrot
//
//  Created by BAE on 3/10/25.
//

enum SortType {
    case none
    case price
    case change
    case amount
}

enum SortState: Int {
    case nonSelected = 0
    case descending = 1
    case ascending = 2
}

class SortManager {
    
    static let shared = SortManager()
    
    private init() { }
    
    var currnetType: SortType = .none
    
    var currnetState: SortState = .nonSelected
    
    func updateType(current: SortType) {
        if currnetType == current {
            nextState()
        } else {
            currnetType = current
            currnetState = .descending
        }
    }
    
    func nextState() {
        switch currnetState {
        case .nonSelected:
            currnetState = .descending
        case .descending:
            currnetState = .ascending
        case .ascending:
            currnetState = .nonSelected
            currnetType = .none
        }
    }
    
    func current() -> String {
        "\(currnetType), \(currnetState)"
    }
    
    
//    private func sort1() {
//        sort2(current: currentSort.sortType)
//    }
//    
//    private func sort2(current: SortType) {
//        
//    }
//    
//    private func sort(current: SortType) -> [MarketData] {
//        /*
//         1. 현재 있는 데이터를
//         2. 현재 정렬 상태에 따라 정렬해서
//         3. 리턴 -> 아웃풋으로 전달
//         
//         tradePrice 현재가
//         change 변화 구분(보합, 상승, 하락)
//         changeRate 변화율
//         changePrice 변화량
//         acc_trade_price_24h 24시간 거래대금
//         */
//        
//        let origin = mockMarketData
//
//        if currentSort.sortType == current {
//            
//        } else {
//            return origin.sorted { lhs, rhs in
//                
//            }
//        }
//        
//        
//        
//        
//        // 현재가 오름차순
//        let sortedList = origin.sorted { $0.tradePrice < $1.tradePrice }
//        
//        return []
//    }
//    
}
