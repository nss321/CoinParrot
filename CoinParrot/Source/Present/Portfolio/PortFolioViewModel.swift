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
        let error: Driver<APIError>
    }
    
    let disposeBag = DisposeBag()
    private let realmProvider: RealmProvider
    private let networkService: NetworkServiceProvider
    private let scheduler: SerialDispatchQueueScheduler
    private let alertManager = AlertManager.shared
    
    init(realm: RealmProvider = try! Realm(),
         networkService: NetworkServiceProvider = NetworkService.shared,
         scheduler: SerialDispatchQueueScheduler = SerialDispatchQueueScheduler(qos: .userInitiated)) {
        self.realmProvider = realm
        self.networkService = networkService
        self.scheduler = scheduler
    }
    
    func transform(input: Input) -> Output {
        let result = BehaviorRelay(value: [CoinDetail]())
        let searchResult = BehaviorRelay(value: [CoinDetail]())
        let errorRelay = PublishRelay<APIError>()

        
        input.viewDidLoadEvent
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<[CoinDetail]> in
                owner.requestLikedCoinList()
                    .catch { error in
                        errorRelay.accept(error as! APIError)
                        return Observable.just([])
                    }
            }
            .share(replay: 1, scope: .whileConnected)
            .bind(to: result)
            .disposed(by: disposeBag)

        input.searchKeyword.orEmpty
            .debounce(.microseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { text in
                text.isEmpty ? result.value : result.value.filter {
                    $0.name.lowercased().hasPrefix(text.lowercased())
                }
            }
            .bind(to: searchResult)
            .disposed(by: disposeBag)
        
        return Output(
            likedCoins: result.asDriver(onErrorJustReturn: []),
            searchResult: searchResult.asDriver(),
            error: errorRelay.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    private func requestLikedCoinList() -> Observable<[CoinDetail]> {
        let coinIds = realmProvider.objects(LikedCoinRealmSchema.self)
        return networkService.callRequest(api: .coinList(coinIds.map {$0.id}), type: [CoinDetail].self)
            .subscribe(on: scheduler)
            .observe(on: MainScheduler.instance)
    }
    
}
