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
        let collectionViewModelSelected: ControlEvent<SearchCoin>
    }
    
    struct Output {
        let result: Driver<[SearchCoin]>
        let isEmpty: Driver<Bool>
        let selectedModel: Driver<SearchCoin>
    }
    
    var disposeBag = DisposeBag()

    let result = PublishRelay<[SearchCoin]>()
    
    func transform(input: Input) -> Output {
        let coinList = PublishRelay<[SearchCoin]>()
        let isEmpty = PublishRelay<Bool>()
        let selectedModel = PublishRelay<SearchCoin>()

        result
            .bind(with: self) { owner, value in
                print("검색 결과", value)
                if value.isEmpty {
                    isEmpty.accept(true)
                } else {
                    isEmpty.accept(false)
                    coinList.accept(value)
                }
            }
            .disposed(by: disposeBag)
        
        input.collectionViewModelSelected
            .bind(with: self) { owner, selected in
                selectedModel.accept(selected)
            }
            .disposed(by: disposeBag)
        
        return Output(
            result: coinList.asDriver(onErrorDriveWith: .empty()),
            isEmpty: isEmpty.asDriver(onErrorDriveWith: .empty()),
            selectedModel: selectedModel.asDriver(onErrorDriveWith: .empty())
        )
    }
    
}
