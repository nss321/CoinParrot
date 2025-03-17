//
//  MarketCollectionViewCell.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

import SnapKit

final class MarketCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "MarketCollectionViewCell"
    
    private let nameLabel = {
        let label = UILabel()
        label.font = .boldPrimary()
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let priceLabel = {
        let label = UILabel()
        label.font = .regularPrimary()
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let changesPercentageLabel = {
        let label = UILabel()
        label.font = .regularPrimary()
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let changesAmountLabel = {
        let label = UILabel()
        label.font = .regularSecondary()
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let amountLabel = {
        let label = UILabel()
        label.font = .regularPrimary()
        label.textColor = .coinParrotNavy
        return label
    }()
    
    override func configLayout() {
        [nameLabel, priceLabel, changesPercentageLabel, changesAmountLabel, amountLabel].forEach { contentView.addSubview($0) }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.75)
            $0.leading.equalToSuperview().inset(Margin.large)
        }
        
        priceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.75)
            $0.trailing.equalToSuperview().inset(ScreenSize.screenWidth*0.5)
        }
        
        changesPercentageLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.75)
            $0.trailing.equalToSuperview().inset(ScreenSize.screenWidth*0.3)
        }
        
        changesAmountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(1.25)
            $0.trailing.equalToSuperview().inset(ScreenSize.screenWidth*0.3)
        }
        
        amountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.75)
            $0.trailing.equalToSuperview().inset(Margin.large)
        }
    }

    func config(item: MarketData) {
        // 종목명
        let coinName = item.market.split(separator: "-")
        nameLabel.text = "\(coinName[1])/\(coinName[0])"
        
        // 현재가
        priceLabel.text = NumberFormatManager.shared.checkNumber(number: item.tradePrice)
        
        // 전일대비 금액, 퍼센티지
        switch item.change {
        case "RISE":
            changesPercentageLabel.textColor = .coinParrotRed
            changesAmountLabel.textColor = .coinParrotRed
        case "FALL":
            changesPercentageLabel.textColor = .coinParrotBlue
            changesAmountLabel.textColor = .coinParrotBlue
        default:
            // EVEN
            changesPercentageLabel.textColor = .coinParrotNavy
            changesAmountLabel.textColor = .coinParrotNavy
        }
        changesPercentageLabel.text = NumberFormatManager.shared.roundedNumeric(number: item.signedChangeRate*100) + "%"
        changesAmountLabel.text = NumberFormatManager.shared.checkNumber(number: item.signedChangePrice)

        // 거래대금
        amountLabel.text = NumberFormatManager.shared.commaNumber(number: item.accTradePrice24h/1000000) + "백만"
    }
    
}
