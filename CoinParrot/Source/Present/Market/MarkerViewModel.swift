//
//  MarkerViewModel.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import Foundation

import RxSwift
import RxCocoa

final class MarkerViewModel: ViewModel {
    
    struct Input {
        let sortByPriceButtonTap: ControlEvent<Void>
        let sortByChangesButtonTap: ControlEvent<Void>
        let sortByAmountButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let dataSource: Driver<[MarketData]>
        let currentSortState: Driver<String>
        let scrollToTop: Driver<Void>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let marketList = BehaviorRelay(value: [MarketData]())
        let currentSortState = PublishRelay<String>()
        let scrollToTop = PublishRelay<Void>()
        
        input.sortByPriceButtonTap
            .bind(with: self) { owner, _ in
                SortManager.shared.updateType(current: .price)
                marketList.accept(owner.sort(origin: marketList.value))
                scrollToTop.accept(())
                currentSortState.accept(SortManager.shared.current())
            }
            .disposed(by: disposeBag)
        
        input.sortByChangesButtonTap
            .bind(with: self) { owner, _ in
                SortManager.shared.updateType(current: .change)
                marketList.accept(owner.sort(origin: marketList.value))
                scrollToTop.accept(())
                currentSortState.accept(SortManager.shared.current())
            }
            .disposed(by: disposeBag)
        
        input.sortByAmountButtonTap
            .bind(with: self) { owner, _ in
                SortManager.shared.updateType(current: .amount)
                marketList.accept(owner.sort(origin: marketList.value))
                scrollToTop.accept(())
                currentSortState.accept(SortManager.shared.current())
            }
            .disposed(by: disposeBag)
        
        // 빈 화면을 보여주지 않기 위해 최초 1회 실행
        NetworkService.shared.callRequest(api: .market, type: [MarketData].self)
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let value):
                    marketList.accept(owner.sort(origin: value))
                case .failure(let error):
                    dump(error)
                }
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name("market"))
            .flatMap { _ in
                NetworkService.shared.callRequest(api: .market, type: [MarketData].self)
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let value):
                    marketList.accept(owner.sort(origin: value))
                case .failure(let error):
                    debugPrint(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            dataSource: marketList.asDriver(),
            currentSortState: currentSortState.asDriver(onErrorDriveWith: .empty()),
            scrollToTop: scrollToTop.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    private func sort(origin: [MarketData]) -> [MarketData] {
        /*
         1. 현재 있는 데이터를
         2. 현재 정렬 상태에 따라 정렬해서
         3. 리턴 -> 아웃풋으로 전달
         
         tradePrice 현재가
         change 변화 구분(보합, 상승, 하락)
         changeRate 변화율
         changePrice 변화량
         acc_trade_price_24h 24시간 거래대금
         */
        
        switch SortManager.shared.currnetType {
        case .none:
            return origin.sorted { $0.accTradePrice24h > $1.accTradePrice24h }
        case .price:
            switch SortManager.shared.currnetState {
            case .nonSelected:
                return origin.sorted { $0.accTradePrice24h > $1.accTradePrice24h }
            case .descending:
                return origin.sorted { $0.tradePrice > $1.tradePrice }
            case .ascending:
                return origin.sorted { $0.tradePrice < $1.tradePrice }
            }
        case .change:
            switch SortManager.shared.currnetState {
            case .nonSelected:
                return origin.sorted { $0.accTradePrice24h > $1.accTradePrice24h }
            case .descending:
                return origin.sorted { $0.signedChangeRate > $1.signedChangeRate }
            case .ascending:
                return origin.sorted { $0.signedChangeRate < $1.signedChangeRate }
            }
        case .amount:
            switch SortManager.shared.currnetState {
            case .nonSelected:
                return origin.sorted { $0.accTradePrice24h > $1.accTradePrice24h }
            case .descending:
                return origin.sorted { $0.accTradePrice24h > $1.accTradePrice24h }
            case .ascending:
                return origin.sorted { $0.accTradePrice24h < $1.accTradePrice24h }
            }
        }
    }
}

