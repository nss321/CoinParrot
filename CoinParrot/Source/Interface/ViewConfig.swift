//
//  ViewConfig.swift
//  CoinParrot
//
//  Created by BAE on 3/6/25.
//

protocol ViewConfig {
    func configLayout()
    func configView()
}

extension ViewConfig where Self: BaseViewController {
    func configBackgroundColor() {
        view.backgroundColor = .systemGroupedBackground
    }
}
