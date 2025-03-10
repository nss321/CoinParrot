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
    
    private func nextState() {
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

}
