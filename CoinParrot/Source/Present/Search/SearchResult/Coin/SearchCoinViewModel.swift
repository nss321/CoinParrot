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
        let emptyResult: Driver<Void>
    }
    
    var disposeBag = DisposeBag()

    let result = PublishRelay<[SearchCoin]>()
    
    func transform(input: Input) -> Output {
        let coinList = PublishRelay<[SearchCoin]>()
        let emptyResult = PublishRelay<Void>()

        result
            .bind(with: self) { owner, value in
                if value.isEmpty {
                    emptyResult.accept(())
                } else {
                    coinList.accept(value)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            result: coinList.asDriver(onErrorDriveWith: .empty()),
            emptyResult: emptyResult.asDriver(onErrorDriveWith: .empty())
        )
    }
    
}
