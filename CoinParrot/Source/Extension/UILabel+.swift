//
//  UILabel+.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

extension UILabel {
    static func marketNavLabel() -> UILabel {
        let label = UILabel()
        label.text = "거래소"
        label.textColor = .coinParrotNavTitle
        label.font = .marketTabNavTitle()
        return label
    }
    
    static func informationNavLabel() -> UILabel {
        let label = UILabel()
        label.text = "가상자산 / 심볼 검색"
        label.textColor = .coinParrotNavy
        label.font = .informationTabNavTitle()
        return label
    }
    
    static func portFolioLabel() -> UILabel {
        let label = UILabel()
        label.text = "포트폴리오"
        label.textColor = .coinParrotNavy
        label.font = .navTitle()
        return label
    }
}
