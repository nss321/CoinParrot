//
//  TrendingCollectionViewCell.swift
//  CoinParrot
//
//  Created by BAE on 3/8/25.
//

import UIKit

import Kingfisher
import SnapKit

final class TrendingCoinCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "TrendingCoinCollectionViewCell"
    
    private let indexLabel = {
        let label = UILabel()
        label.font = .regularPrimary()
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let coinImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = 13
        return view
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .boldPrimary()
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let subTitleLabel = {
        let label = UILabel()
        label.font = .regularSecondary()
        label.textColor = .coinParrotGray
        return label
    }()
    
    private let changesSymbolImageView = UIImageView()
    
    private let changesLabel = {
        let label = UILabel()
        label.font = .boldSecondary()
        label.textColor = .coinParrotNavy
        return label
    }()
    
    
    override func configLayout() {
        [indexLabel, coinImageView, titleLabel, subTitleLabel, changesSymbolImageView, changesLabel].forEach { contentView.addSubview($0) }
        
        indexLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(Margin.large)
        }
        
        coinImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(indexLabel.snp.leading).offset(Margin.large)
            $0.size.equalTo(26)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(coinImageView.snp.top)
            $0.leading.equalTo(coinImageView.snp.trailing).offset(Margin.small/2)
            $0.trailing.lessThanOrEqualTo(changesSymbolImageView.snp.leading)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(coinImageView.snp.bottom)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
        }
        
        changesSymbolImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(Margin.medium/2)
            $0.height.equalTo(Margin.small)
            $0.trailing.equalTo(changesLabel.snp.leading).offset(-Margin.small/4)
        }
        
        changesLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Margin.large)
        }
    }

    func config(item: TrendingCoinDetails, index: Int) {
        indexLabel.text = String(index)
        
        coinImageView.kf.indicatorType = .activity
        
        if let url = URL(string: item.small) {
            coinImageView.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .success(_): break
//                    print("image load success", value)
                case .failure(let error):
                    print("error occured", error)
                    self?.coinImageView.image = UIImage(systemName: "xmark")?.withTintColor(.coinParrotGray, renderingMode: .alwaysOriginal)
                }
            }
        } else {
            coinImageView.image = UIImage(systemName: "xmark")?.withTintColor(.coinParrotGray, renderingMode: .alwaysOriginal)
        }
        
        titleLabel.text = item.symbol
        
        subTitleLabel.text = item.name
        
        if let changes = item.data.priceChangePercentage24h["krw"] {
            
            if changes < 0 {
                changesLabel.textColor = .coinParrotBlue
                changesSymbolImageView.image = UIImage(systemName: "arrowtriangle.down.fill")?.withTintColor(.coinParrotBlue, renderingMode: .alwaysOriginal)
                changesLabel.text = NumberFormatManager.shared.roundedNumeric(number: -changes) + "%"
                
            } else if changes > 0 {
                changesLabel.textColor = .coinParrotRed
                changesSymbolImageView.image = UIImage(systemName: "arrowtriangle.up.fill")?.withTintColor(.coinParrotRed, renderingMode: .alwaysOriginal)
                changesLabel.text = NumberFormatManager.shared.roundedNumeric(number: changes) + "%"
                
            } else {
                changesLabel.textColor = .coinParrotNavy
                changesLabel.text = NumberFormatManager.shared.roundedNumeric(number: changes) + "%"
            }
        }
    }
}
