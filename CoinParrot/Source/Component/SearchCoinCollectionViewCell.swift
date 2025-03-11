//
//  SearchCoinCollectionViewCell.swift
//  CoinParrot
//
//  Created by BAE on 3/9/25.
//

import UIKit

import Kingfisher
import SnapKit

final class SearchCoinCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "SearchCoinCollectionViewCell"
    
    private let coinImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = 18
        return view
    }()
    
    private let symbolLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let nameLabel = {
        let label = UILabel()
        label.font = .regularPrimary()
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let rankLabel = {
        let label = UIButton()
        var config = UIButton.Configuration.gray()
        config.baseForegroundColor = .coinParrotGray
        config.cornerStyle = .large
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        label.configuration = config
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private let starButton = StarButton()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coinImageView.image = nil
        symbolLabel.text = nil
        nameLabel.text = nil
    }
    
    override func configLayout() {
        [coinImageView,symbolLabel,nameLabel,rankLabel,starButton].forEach { contentView.addSubview($0) }
        
        coinImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(largeMargin)
            $0.size.equalTo(36)
        }
        
        symbolLabel.snp.makeConstraints{
            $0.top.equalTo(coinImageView.snp.top)
            $0.leading.equalTo(coinImageView.snp.trailing).offset(mediumMargin)
        }
        
        nameLabel.snp.makeConstraints{
            $0.bottom.equalTo(coinImageView.snp.bottom)
            $0.leading.equalTo(symbolLabel.snp.leading)
            $0.trailing.lessThanOrEqualTo(starButton.snp.leading)
        }
        
        rankLabel.snp.makeConstraints{
            $0.top.equalTo(symbolLabel.snp.top)
            $0.leading.equalTo(symbolLabel.snp.trailing)
        }
        
        starButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(largeMargin)
        }
    }

    func config(item: SearchCoin) {
        coinImageView.kf.indicatorType = .activity
        
        coinImageView.kf.indicatorType = .activity
        if let url = URL(string: item.thumb) {
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
        
        symbolLabel.text = item.symbol
        
        nameLabel.text = item.name
        
        rankLabel.configuration?.attributedTitle = attribRank(rank: item.marketCapRank)

        rankLabel.snp.remakeConstraints {
            $0.top.equalTo(symbolLabel.snp.top)
            $0.height.equalTo(symbolLabel.intrinsicContentSize.height)
            $0.leading.equalTo(symbolLabel.snp.trailing).offset(smallMargin/2)
        }
        
        starButton.bind(viewModel: StarButtonViewModel(item: LikedCoin(id: item.id)))
    }
    
    private func attribRank(rank: Int?) -> AttributedString {
        var mutableString: NSMutableAttributedString
        if let rank {
            mutableString = NSMutableAttributedString(string: "#\(rank)")
        } else {
            mutableString = NSMutableAttributedString(string: "unranked")
        }
        mutableString.setAttributes(
            [.font : UIFont.boldSecondary(), .foregroundColor : UIColor.coinParrotGray],
            range: NSRange(location: 0, length: mutableString.string.count)
        )
        return AttributedString(mutableString)
    }
}
