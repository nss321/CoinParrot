//
//  SortButton.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

enum SortState: Int {
    case nonSelected = 0
    case descending = 1
    case ascending = 2
}

final class SortButton: UIButton, ViewConfig {
    
    var sort: SortState = .nonSelected
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configLayout()
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init()
        configuration = .sortButtonStyle(title: title)
    }
    
    func configLayout() {
        
    }
    
    func configView() {
        addAction(UIAction(handler: { [weak self] _ in
            switch self?.sort {
            case .nonSelected:
                self?.sort = .descending
            case .descending:
                self?.sort = .ascending
            case .ascending:
                self?.sort = .nonSelected
            case .none:
                self?.sort = .nonSelected
                print("Error Occured. Button State changed Non-Selected.")
            }
            print(self?.sort.rawValue)
        }), for: .touchUpInside)
    }
    
}
