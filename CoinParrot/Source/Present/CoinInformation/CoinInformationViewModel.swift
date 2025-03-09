//
//  CoinInformationViewModel.swift
//  CoinParrot
//
//  Created by BAE on 3/8/25.
//

import RxSwift
import RxCocoa

final class CoinInformationViewModel: ViewModel {
    struct Input {
        let searchButtonClicked: ControlEvent<Void>
        let searchBarText: ControlProperty<String?>
    }
    
    struct Output {
        let mockDataSource: Driver<[TrendingHeader]>
        let output: Driver<String>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let test = PublishRelay<String>()
        let isValid = PublishRelay<Void>()
        let mockData = BehaviorRelay(value: [TrendingHeader]())
        
        input.searchButtonClicked
            .throttle(.microseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchBarText.orEmpty)
            .compactMap {
                KeywordValidation.checkValidation(text: $0)
            }
            .bind(with: self) { owner, valid in
                switch valid {
                case .empty:
                    AlertManager.shared.showSimpleAlert(title: "검색어", message: KeywordValidation.empty.message) 
//                case .short:
//                    AlertManager.shared.showSimpleAlert(title: "검색어", message: KeywordValidation.short.message)
                case .valid:
                    isValid.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        isValid
            .withLatestFrom(input.searchBarText.orEmpty)
            .bind(to: test)
            .disposed(by: disposeBag)
        
        let mockDataObservable = Observable.zip(
            Observable.just(mockTrendingCoins),
            Observable.just(mockTrendingNFTs)
        )
        .map { trendingCoins, trendingNFTs in
            let coinSection = TrendingHeader(title: "인기 검색어", subTitle: "02.16 00:30 기준", items: Array(trendingCoins)[0...13].map { Trending.coin($0.item) })
            let nftSection = TrendingHeader(title: "인기 NFT", subTitle: nil, items: trendingNFTs.map { Trending.nft($0) })
            return [coinSection, nftSection]
        }
    
        mockDataObservable
            .bind(with: self) { owner, value in
                mockData.accept(value)
            }
            .disposed(by: disposeBag)
        
        return Output(
            mockDataSource: mockData.asDriver(),
            output: test.asDriver(onErrorDriveWith: .empty())
        )
    }
}
