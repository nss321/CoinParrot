//
//  SearchCoinViewModel.swift
//  CoinParrot
//
//  Created by BAE on 3/9/25.
//

import RxSwift
import RxCocoa

final class SearchCoinViewModel: ViewModel {
    
    struct Input {
    }
    
    struct Output {
        let result: Driver<[SearchCoin]>
    }
    
    var disposeBag = DisposeBag()

    let result = BehaviorRelay(value: [SearchCoin]())
    
    func transform(input: Input) -> Output {

        let coinList = BehaviorRelay(value: [SearchCoin]())

        result
            .bind(to: coinList)
            .disposed(by: disposeBag)
        
        return Output(
            result: coinList.asDriver()
        )
    }
    
}
