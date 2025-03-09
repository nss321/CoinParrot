//
//  NetworkManager.swift
//  CoinParrot
//
//  Created by BAE on 3/8/25.
//

import Foundation

import Alamofire
import RxSwift
import RxCocoa

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init () { }
    
    func callMarketList() {
        
    }
    
    func callSearchAPI<T: Decodable>(api: CoinGeckoRequest, type: T.Type) -> Single<Result<T, APIError>> {
        
        return Single.create { value in
            
            AF.request(api.endpoint,
                       method: api.method,
                       headers: api.header) { request in
                // TODO: 네트워크 요청이 길어질 때 처리(10초, 30초 등)
                request.cachePolicy = .returnCacheDataElseLoad
            }
                       .validate(statusCode: 200...299)
                       .responseDecodable(of: T.self) { response in
//                           debugPrint(response)
                           switch response.result {
                           case .success(let result):
                               value(.success(.success(result)))
                               break
                           case .failure(let error):
                               if let status = response.response?.statusCode {
                                   switch status {
                                   case 400:
                                       value(.success(.failure(APIError.invalidQuery)))
                                   case 403:
                                       value(.success(.failure(APIError.unauthorizedAccess)))
                                   case 404:
                                       value(.success(.failure(APIError.notFound)))
                                   case 500:
                                       value(.success(.failure(APIError.systemError)))
                                   default:
                                       value(.success(.failure(APIError.unknownResponse)))
                                   }
                               }
                               dump(error)
                           }
                       }
            return Disposables.create {
                print("통신끝")
            }
        }
    }
}
