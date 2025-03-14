//
//  MarketHeaderView.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

import SnapKit

final class MarketHeaderView: BaseView {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        [coinNameColumnLabel, sortByPriceButton, sortByChangesButton, sortByAmountButton]
            .forEach { addSubview($0) }
        
        coinNameColumnLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(appDelegate.largeMargin)
        }
        sortByPriceButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.width.equalTo(sortByPriceButton.title.intrinsicContentSize.width + CGFloat(appDelegate.mediumMargin))
            $0.trailing.equalToSuperview().inset(appDelegate.screenWidth*0.5)
        }
        sortByChangesButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.width.equalTo(sortByChangesButton.title.intrinsicContentSize.width + CGFloat(appDelegate.mediumMargin))
            $0.trailing.equalToSuperview().inset(appDelegate.screenWidth*0.3)
        }
        sortByAmountButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.width.equalTo(sortByAmountButton.title.intrinsicContentSize.width + CGFloat(appDelegate.mediumMargin))
            $0.trailing.equalToSuperview().inset(appDelegate.largeMargin)
        }
    }
    
    override func configView() {
        backgroundColor = .coinParrotGray.withAlphaComponent(0.1)
    }
    
}
