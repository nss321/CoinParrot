//
//  TrendingCollectionViewHeader.swift
//  CoinParrot
//
//  Created by BAE on 3/8/25.
//

import UIKit

import SnapKit

final class TrendingCollectionViewHeader: UICollectionReusableView, ViewConfig {
    
    static let id = "TrendingCollectionViewHeader"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .coinParrotNavy
        label.textAlignment = .left
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .coinParrotGray
        label.textAlignment = .right
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configLayout() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(Margin.large)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Margin.large)
        }
    }
    
    func configView() { }
    
    func config(dataSource: TrendingHeader) {
        titleLabel.text = dataSource.title
        subTitleLabel.text = dataSource.subTitle
    }
    
}
