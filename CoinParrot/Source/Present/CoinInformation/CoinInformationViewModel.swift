//
//  CoinInformationViewModel.swift
//  CoinParrot
//
//  Created by BAE on 3/8/25.
//

import Foundation

import RxSwift
import RxCocoa

final class CoinInformationViewModel: ViewModel {
    struct Input {
        let searchButtonClicked: ControlEvent<Void>
        let searchBarText: ControlProperty<String?>
    }
    
    struct Output {
        let dataSource: Driver<[TrendingHeader]>
        let searchKeyword: Driver<String>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let test = PublishRelay<String>()
        let isValid = PublishRelay<Void>()
        let trendHeader = BehaviorRelay(value: [TrendingHeader]())
        
        // 뷰 진입시 캐시에서 데이터를 꺼내옴.
        Observable.just(())
            .flatMap({ _ in
                NetworkManager.shared.loadTrendingData()
            })
            .bind(with: self) { owner, cache in
                switch cache {
                case .success(let value):
                    trendHeader.accept(owner.modifyResponse(response: value))
                case .failure(let error):
                    debugPrint(error)
                }
            }
            .disposed(by: disposeBag)
        
        // 10분마다
        NotificationCenter.default.rx.notification(Notification.Name("trend"))
            .flatMap { _ in
                NetworkManager.shared.loadTrendingData()
            }
            .bind(with: self) { owner, response in
                print("노티 받음")
                switch response {
                case .success(let value):
                    trendHeader.accept(owner.modifyResponse(response: value))
                case .failure(let error):
                    debugPrint(error)
                }
            }
            .disposed(by: disposeBag)
        
    
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
                case .valid:
                    isValid.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        isValid
            .withLatestFrom(input.searchBarText.orEmpty)
            .bind(to: test)
            .disposed(by: disposeBag)
        
        return Output(
            dataSource: trendHeader.asDriver(),
            searchKeyword: test.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    private func modifyResponse(response: TrendingResponse) -> [TrendingHeader] {
        // TODO: DateManager 만들어서 날짜 데이터 가공해야함
        let coinSection = TrendingHeader(title: "인기 검색어", subTitle: "\(Date.now)", items: response.coins[0...13].map { Trending.coin($0.item) })
        let nftSection = TrendingHeader(title: "인기 NFT", subTitle: nil, items: response.nfts.map { Trending.nft($0) })
        return [coinSection, nftSection]
    }
}
