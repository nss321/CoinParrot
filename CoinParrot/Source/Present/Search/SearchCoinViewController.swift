//
//  SearchCoinViewController.swift
//  CoinParrot
//
//  Created by BAE on 3/8/25.
//

import UIKit

import SnapKit

final class SearchCoinViewController: BaseViewController {
    private let label = {
        let label = UILabel()
        label.text = "Search Coin Here."
        label.font = .boldPrimary()
        label.textColor = .coinParrotNavy
        return label
    }()
    
    override func configLayout() {
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
