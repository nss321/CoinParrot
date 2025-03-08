//
//  ViewConfig.swift
//  CoinParrot
//
//  Created by BAE on 3/6/25.
//

import Foundation

@objc
protocol ViewConfig {
    @objc optional func bind()
    func configLayout()
    func configView()
}

extension ViewConfig where Self: BaseViewController{
    func configBackgroundColor() {
        view.backgroundColor = .white
    }
}
