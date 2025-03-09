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
        let mockDataSource: Driver<[SearchCoin]>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let mockData = BehaviorRelay(value: [SearchCoin]())
        
        Observable.just(mockSearchCoin)
            .bind(with: self) { owner, result in
                mockData.accept(result)
            }
            .disposed(by: disposeBag)
        
//        mockData.accept(mockMarketData)
        
        
        return Output(
            mockDataSource: mockData.asDriver()
        )
    }
    
}
