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
        
        return Output(
            coinDetailInformation: coinDetail.asDriver()
        )
    }
}
