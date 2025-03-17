//
//  DateManager.swift
//  CoinParrot
//
//  Created by BAE on 3/11/25.
//

import UIKit


final class DateManager {
    
    enum DatePresent {
        case coinInformationView
        case coinDetailViewChart
        case coinDetailViewAllTime
    }
    
    static let shared = DateManager()
    
    private init() { }
    
    private lazy var chartDataFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd HH:mm:ss 업데이트"
        return formatter
    }()
    
    private lazy var allTimeFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 M월 d일"
        return formatter
    }()
    
    private lazy var trendingDataFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd HH:mm 기준"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }()
    
    private lazy var isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    func iso8601ToString(date: String?, type: DatePresent) -> String {
        guard let date = date, let date = isoFormatter.date(from: date) else {
            return "날짜를 불러올 수 없습니다."
        }
        
        switch type {
        case .coinInformationView:
            return chartDataFormatter.string(from: date)
        case .coinDetailViewChart:
            return chartDataFormatter.string(from: date)
        case .coinDetailViewAllTime:
            return allTimeFormatter.string(from: date)
        }
    }
    
    func nowDate() -> String {
        return trendingDataFormatter.string(from: .now)
    }

}
