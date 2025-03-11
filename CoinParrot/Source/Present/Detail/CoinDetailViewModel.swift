//
//  CoinDetailViewModel.swift
//  CoinParrot
//
//  Created by BAE on 3/11/25.
//

import RxSwift
import RxCocoa

final class CoinDetailViewModel: ViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        let coinDetailInformation: Driver<[CoinDetail]>
    }
    
    let coinId: String
    
    var disposeBag = DisposeBag()

    init(coinId: String) {
        self.coinId = coinId
    }
    
    func transform(input: Input) -> Output {
        let coinIdRelay = BehaviorRelay(value: coinId)
        let coinDetail = BehaviorRelay(value: [CoinDetail]())
        
        coinIdRelay
            .flatMap {
                NetworkManager.shared.callRequest(api: .detail($0), type: [CoinDetail].self)
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let value):
                    coinDetail.accept(value)
                case .failure(let error):
                    dump(error)
                }
            }
            .disposed(by: disposeBag)

//        var count = 0
        
//        let test: Observable<[CoinDetail]> = NetworkManager.shared.callRequest(api: .detail(coinId), type: [CoinDetail].self)
//                
//        test
//            .observe(on: MainScheduler.asyncInstance)
//            .retry { error in
//                error.enumerated()
//                    .flatMap { count, error -> Observable<Void> in
//                        guard count < 3 else { throw error }
//                        return Observable<Void>.just(())
//                            .delay(.seconds(1), scheduler: MainScheduler.asyncInstance)
//                    }
//            }
//            .subscribe(with: self) { owenr, value in
//                coinDetail.accept(value)
//            } onError: { owner, error in
//                let apiError = error as! APIError
//                AlertManager.shared.showSimpleAlert(title: "네트워크 에러", message: apiError.rawValue)
//            } onCompleted: { owner in
//                print("completer")
//            } onDisposed: { owner in
//                print("disposed")
//            }
//            .disposed(by: disposeBag)

        
        return Output(
            coinDetailInformation: coinDetail.asDriver()
        )
    }
}
