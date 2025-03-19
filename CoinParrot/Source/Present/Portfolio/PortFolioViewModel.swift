//
//  PortFolioViewModel.swift
//  CoinParrot
//
//  Created by BAE on 3/17/25.
//

import RealmSwift
import RxSwift
import RxCocoa

final class PortFolioViewModel: ViewModel {
    
    struct Input {
        let viewDidLoadEvent: PublishRelay<Void>
        let searchKeyword: ControlProperty<String?>
    }
    
    struct Output {
        let likedCoins: Driver<[CoinDetail]>
        let searchResult: Driver<[CoinDetail]>
    }
    
    let disposeBag = DisposeBag()
    private let networkService: NetworkServiceProvider
    private let scheduler: SerialDispatchQueueScheduler
    private let alertManager = AlertManager.shared
    
    init(networkService: NetworkServiceProvider = NetworkService.shared, scheduler: SerialDispatchQueueScheduler = SerialDispatchQueueScheduler(qos: .userInitiated)) {
        self.networkService = networkService
        self.scheduler = scheduler
    }
    
    func transform(input: Input) -> Output {
        let result = BehaviorRelay(value: [CoinDetail]())
        let searchResult = BehaviorRelay(value: [CoinDetail]())
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<[CoinDetail]> in
                owner.requestLikedCoinList()
            }
            .share(replay: 1, scope: .whileConnected)
            .bind(to: result)
            .disposed(by: disposeBag)

        input.searchKeyword
            .withLatestFrom(input.searchKeyword.orEmpty)
            .bind(with: self) { owner, text in
                let filtered = text.isEmpty ? result.value : result.value.filter {
                    $0.name.lowercased().hasPrefix(text.lowercased())
                }
                searchResult.accept(filtered)
            }
            .disposed(by: disposeBag)
        
        return Output(
            likedCoins: result.asDriver(onErrorJustReturn: []),
            searchResult: searchResult.asDriver()
        )
    }
    
    private func requestLikedCoinList() -> Observable<[CoinDetail]> {
        let realm = try! Realm()
        let coinIds = realm.objects(LikedCoinRealmSchema.self)
        return networkService.callRequest(api: .coinList(coinIds.map {$0.id}), type: [CoinDetail].self)
            .subscribe(on: scheduler)
            .observe(on: MainScheduler.instance)
            .catch { error in
                self.alertManager.showSimpleAlert(title: "에러", message: error.localizedDescription)
                return Observable.just([])
            }
    }
    
}
