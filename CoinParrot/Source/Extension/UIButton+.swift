//
//  UIButton+.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

extension UIButton.Configuration {
    static func sortButtonStyle(title: String) -> UIButton.Configuration {
        var attribString = AttributedString(title)
        attribString.font = .boldSecondary()
        var config = UIButton.Configuration.plain()
        config.attributedTitle = attribString
        config.baseForegroundColor = .coinParrotNavy
        config.background.backgroundColor = .clear
        return config
    }
}
