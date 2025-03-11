//
//  DateManager.swift
//  CoinParrot
//
//  Created by BAE on 3/11/25.
//

import UIKit


final class DateManager {
    
    static let shared = DateManager()
    
    private init() { }
    
    private lazy var chartDataFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd HH:mm:ss 업데이트"
        return formatter
    }()
    
    private lazy var trendingDataFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd HH:mm 기준"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }()
    
    private lazy var responseTrendingDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return formatter
    }()
    
    private lazy var isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    func iso8601ToString(date: String?) -> String {
//        print(date)
        if let date = date, let date = isoFormatter.date(from: date) {
            return chartDataFormatter.string(from: date)
        } else {
            return  "날짜를 불러올 수 없습니다."
        }
    }
    
    func trendingDateToString(date: String?) -> String {
        if let date = date, let date = responseTrendingDateFormatter.date(from: date) {
            return trendingDataFormatter.string(from: date)
        } else {
            return "날짜를 불러올 수 없습니다."
        }
    }

}
