//
//  BaseCollectionViewCell.swift
//  CoinParrot
//
//  Created by BAE on 3/8/25.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, ViewConfig {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configLayout()
        configView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configLayout() { }
    
    func configView() {
        backgroundColor = .white
    }
    
}
