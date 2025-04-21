//
//  APIError.swift
//  CoinParrot
//
//  Created by BAE on 3/20/25.
//

enum APIError: String, Error {
    case invalidQuery = "잘못된 쿼리입니다."
    case unauthorizedAccess = "인증되지 않은 토큰입니다."
    case notFound = "잘못된 요청입니다."
    case systemError = "백엔드 잘못입니다."
    case unknownResponse = "알 수 없는 오류입니다."
    
    var message: String {
        return rawValue
    }
}
