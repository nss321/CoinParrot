//
//  MarkerViewModel.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import RxSwift
import RxCocoa

final class MarkerViewModel: ViewModel {
    
    struct Input {
        let sortByPriceButtonTap: ControlEvent<Void>
        let sortByChangesButtonTap: ControlEvent<Void>
        let sortByAmountButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let mockDataSource: Driver<[MarketData]>
        let output: Driver<Void>
    }
    
    var sort: SortState = .nonSelected
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let mockData = BehaviorRelay(value: [MarketData]())
        let test = PublishRelay<Void>()
        
        [
            input.sortByPriceButtonTap,
            input.sortByChangesButtonTap,
            input.sortByAmountButtonTap
        ].forEach { tap in
            tap
                .bind(with: self) { owner, _ in
                    test.accept(())
                }
                .disposed(by: disposeBag)
        }
        
        mockData.accept(mockMarketData)
        
        
        return Output(
            mockDataSource: mockData.asDriver(),
            output: test.asDriver(onErrorDriveWith: .empty())
        )
    }
    
}
