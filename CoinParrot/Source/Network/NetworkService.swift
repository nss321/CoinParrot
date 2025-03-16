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

final class NetworkService {
    static let shared = NetworkService()
        
    private init() { }
    
    /// fetching market data overwrite origin data, every 5 second.
    func fetchMarketData() {
        let api = APIRequest.market
        AF.request(api.endpoint, method: api.method) {
            $0.cachePolicy = .reloadIgnoringLocalCacheData
        }
        .validate()
        .responseData { response in
            switch response.result {
            case .success(_):
                print("market data fetch succeed, response is cached.")
            case .failure(let error):
                print("failed to fetch trending data >>>")
                dump(error)
            }
        }
    }
    
    /// fetching trend data overwrite origin cached data, every 10 minutes.
    func fetchTrendingData() {
        let api = APIRequest.trending
        AF.request(api.endpoint, method: api.method, headers: api.header) {
            $0.cachePolicy = .reloadIgnoringLocalCacheData
        }
        .validate()
        .responseData { response in
            switch response.result {
            case .success(_):
                print("trending data fetch succeed, response is cached.")
            case .failure(let error):
                print("failed to fetch trending data >>>")
                dump(error)
            }
        }
    }
    
    /// load trend data from cache.
    func loadTrendingData() -> Single<Result<TrendingResponse, APIError>> {
        return Single.create { value in
            let api = APIRequest.trending
            AF.request(api.endpoint, method: api.method, headers: api.header) {
                $0.cachePolicy = .returnCacheDataElseLoad
            }
            .validate()
            .responseDecodable(of: TrendingResponse.self, completionHandler: { response in
//                dump(response)
                switch response.result {
                case .success(let data):
                    value(.success(.success(data)))
                case .failure(_):
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
//                    dump(error)
//                    debugPrint(error)
                }
            })
            return Disposables.create {
                print("데이터 로드 완료")
            }
        }
    }
    
    func callRequest<T: Decodable>(api: APIRequest, type: T.Type) -> Single<Result<T, APIError>> {
        
        return Single.create { value in
            
            AF.request(api.endpoint, method: api.method, headers: api.header) { request in
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
    
    // retry를 활용해 네트워크 에러를 처리하기 위해 오버로딩
    func callRequest<T: Decodable>(api: APIRequest, type: T.Type) -> Observable<T> {
        
        return Observable<T>.create { value in
            AF.request(api.endpoint, method: api.method, headers: api.header) { request in
                // TODO: 네트워크 요청이 길어질 때 처리(10초, 30초 등)
                request.cachePolicy = .returnCacheDataElseLoad
            }
            .validate(statusCode: 200...299)
            .responseDecodable(of: T.self) { response in
                
                switch response.result {
                case .success(let result):
                    value.onNext(result)
                    value.onCompleted()
                    break
                case .failure(let error):
                    if let status = response.response?.statusCode {
                        switch status {
                        case 400:
                            value.onError(APIError.invalidQuery)
                        case 403:
                            value.onError(APIError.unauthorizedAccess)
                        case 404:
                            value.onError(APIError.notFound)
                        case 500:
                            value.onError(APIError.systemError)
                        default:
                            value.onError(APIError.unknownResponse)
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
