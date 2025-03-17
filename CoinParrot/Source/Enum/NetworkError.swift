//
//  NetworkError.swift
//  CoinParrot
//
//  Created by BAE on 3/17/25.
//

enum NetworkError {
    case loss
    
    var message: String {
        switch self {
        case .loss:
            return "네트워크 연결이 일시적으로 원활하지 않습니다. 데이터 또는 Wi-Fi 연결 상태르르 확인해주세요."
        }
    }
}
