//
//  UIButton+.swift
//  CoinParrot
//
//  Created by BAE on 3/11/25.
//

import UIKit

extension UIButton.Configuration {
    static func moreButtonStyle(title: String) -> Self {
        var config = Self.plain()
        config.attributedTitle = AttributedString(NSAttributedString(string: title, attributes: [
            .font : UIFont.systemFont(ofSize: 14),
            .foregroundColor : UIColor.coinParrotGray
        ]))
        config.image = UIImage(systemName: "chevron.right")?.withTintColor(.coinParrotGray, renderingMode: .alwaysOriginal)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 10))
        config.imagePadding = 4
        config.imagePlacement = .trailing
        config.background.backgroundColor = .white
        return config
    }
    
    static func starButton() -> Self {
        var config = Self.plain()
        config.image = UIImage(systemName: "star")?.withTintColor(.coinParrotNavy, renderingMode: .alwaysOriginal)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14))
        config.background.backgroundColor = .clear
        return config
    }
}
