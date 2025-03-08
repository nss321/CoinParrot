//
//  NumberFormatManager.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import Foundation

final class NumberFormatManager {
    static let shared = NumberFormatManager()
    
    private let formatter = NumberFormatter()
    
    private init() { }
    
    /// Add comma to Int
    func commaNumber(number: Double) -> String {
        formatter.numberStyle = .decimal
        if let number = formatter.string(for: Int(number)) {
            return number
        } else {
            print(#function, "문자열을 변환할 수 없음!!")
            return ""
        }
    }

    /// Rounding to 2 decimal place
    func roundedNumeric(number: Double) -> String {
        let digit: Double = pow(10, 2)
        let roundedNumber = round(number * digit) / digit
        return String(roundedNumber)
    }
}
