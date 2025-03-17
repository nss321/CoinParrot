//
//  ScreenSize.swift
//  CoinParrot
//
//  Created by BAE on 3/17/25.
//

import UIKit

struct ScreenSize {
    static var screenWidth: CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            fatalError()
        }
        return window.screen.bounds.width
    }
    
    static var screenHeight: CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            fatalError()
        }
        return window.screen.bounds.height
    }
}
