//
//  TrendingNFTCollectionViewCell.swift
//  CoinParrot
//
//  Created by BAE on 3/9/25.
//

import UIKit

import Kingfisher
import SnapKit

final class TrendingNFTCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "TrendingNFTCollectionViewCell"
    
    private let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .boldSecondary()
        label.textColor = .coinParrotNavy
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let priceLabel = {
        let label = UILabel()
        label.font = .regularSecondary()
        label.textColor = .coinParrotGray
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let changesContainer = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 2
        return view
    }()
    
    private let changesSymbolImageView = UIImageView()
    
    private let changesLabel = {
        let label = UILabel()
        label.font = .boldSecondary()
        label.textColor = .coinParrotNavy
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let formatter = NumberFormatManager.shared
    
    override func configLayout() {
        [imageView, titleLabel, priceLabel, changesContainer].forEach { contentView.addSubview($0) }
        
        [changesSymbolImageView, changesLabel].forEach { changesContainer.addArrangedSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(smallMargin)
            $0.size.equalTo(72)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(smallMargin/2)
            $0.horizontalEdges.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        changesContainer.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        changesSymbolImageView.snp.makeConstraints {
            $0.width.equalTo(mediumMargin/2)
            $0.height.equalTo(smallMargin)
        }
    }

    func config(item: TrendingNFTItem) {
        if let url = URL(string: item.thumb) {
            imageView.kf.setImage(with: url){ [weak self] result in
                switch result {
                case .success(let value):
                    print("image load success", value)
                case .failure(let error):
                    print("error occured", error)
                    self?.imageView.image = UIImage(systemName: "xmark")?.withTintColor(.coinParrotGray, renderingMode: .alwaysOriginal)
                }
            }
        } else {
            imageView.image = UIImage(systemName: "xmark")
        }
        titleLabel.text = item.name
        priceLabel.text = item.data.floorPrice
        changesLabel.text = formatter.roundedNumeric(number: item.floorPrice24hPercentageChange)
        
        let changes = item.floorPrice24hPercentageChange
        if changes < 0 {
            changesLabel.textColor = .coinParrotBlue
            changesSymbolImageView.image = UIImage(systemName: "arrowtriangle.down.fill")?.withTintColor(.coinParrotBlue, renderingMode: .alwaysOriginal)
            changesLabel.text = formatter.roundedNumeric(number: -changes) + "%"
        } else if changes > 0 {
            changesLabel.textColor = .coinParrotRed
            changesSymbolImageView.image = UIImage(systemName: "arrowtriangle.up.fill")?.withTintColor(.coinParrotRed, renderingMode: .alwaysOriginal)
            changesLabel.text = formatter.roundedNumeric(number: changes) + "%"
        } else {
            changesLabel.textColor = .coinParrotNavy
            changesLabel.text = formatter.roundedNumeric(number: changes) + "%"
        }
    }
}
