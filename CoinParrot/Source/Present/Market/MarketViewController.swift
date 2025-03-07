//
//  MarketViewController.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

final class MarketViewController:  BaseViewController {
    
    override func bind() {
        
    }
    
    override func configLayout() {
        
    }
    
    override func configView() {
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: UILabel.marketNavLabel()), animated: false)
    }
    
}
