//
//  MarketHeaderView.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

import SnapKit

final class MarketHeaderView: BaseView {
    
    private let borderLine = {
        let view = UIView()
        view.backgroundColor = .coinParrotGray.withAlphaComponent(0.3)
        return view
    }()
    
    private let coinNameColumnLabel = {
        let label = UILabel()
        label.text = "코인"
        label.font = .boldPrimary()
        label.textColor = .coinParrotNavy
        label.textAlignment = .left
        return label
    }()
    let sortByPriceButton = SortButton(title: "현재가")
    let sortByChangesButton = SortButton(title: "전일대비")
    let sortByAmountButton = SortButton(title: "거래대금")
    
    override func configLayout() {
        [borderLine, coinNameColumnLabel, sortByPriceButton, sortByChangesButton, sortByAmountButton]
            .forEach { addSubview($0) }
        
        borderLine.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        coinNameColumnLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(largeMargin)
        }
        sortByPriceButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(screenWidth*0.5)
        }
        sortByChangesButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(screenWidth*0.3)
        }
        sortByAmountButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(largeMargin)
        }
    }
    
    override func configView() {
        backgroundColor = .coinParrotGray.withAlphaComponent(0.1)
    }
    
}
