//
//  MarketHeaderView.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

import SnapKit

final class MarketHeaderView: BaseView {
    private let coinNameColumnLabel = {
        let label = UILabel()
        label.text = "코인"
        label.font = .boldSecondary()
        label.textColor = .coinParrotNavy
        label.textAlignment = .left
        return label
    }()
    private let coinPriceSortButton = {
        let button = UIButton()
        button.configuration = .sortButtonStyle(title: "현재가")
        return button
    }()
    private let priceChangesSortButton = {
        let button = UIButton()
        button.configuration = .sortButtonStyle(title: "전일대비")
        return button
    }()
    private let tradeAmountSortButton = {
        let button = UIButton()
        button.configuration = .sortButtonStyle(title: "거래대금")
        return button
    }()
    
    override func configLayout() {
        
    }
    
    override func configView() {
    
    }
}
