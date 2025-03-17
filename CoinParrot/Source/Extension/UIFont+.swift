//
//  UIFont+.swift
//  CoinParrot
//
//  Created by BAE on 3/6/25.
//

import UIKit

extension UIFont {
    /// bold, 12
    static func boldPrimary() -> UIFont { return UIFont.boldSystemFont(ofSize: 12) }
    /// bold, 9
    static func boldSecondary() -> UIFont { return UIFont.boldSystemFont(ofSize: 9) }
    /// regular, 12
    static func regularPrimary() -> UIFont { return UIFont.systemFont(ofSize: 12) }
    /// regular, 9
    static func regularSecondary() -> UIFont { return UIFont.systemFont(ofSize: 9) }
    
    /// heavy, 18, brown
    static func marketTabNavTitle() -> UIFont { return UIFont.systemFont(ofSize: 18, weight: .heavy) }
    
    /// heavy, 18, coinParrotNavy
    static func informationTabNavTitle() -> UIFont { return UIFont.systemFont(ofSize: 18, weight: .heavy) }
    
    static func navTitle() -> UIFont { return UIFont.systemFont(ofSize: 18, weight: .heavy) }
}

