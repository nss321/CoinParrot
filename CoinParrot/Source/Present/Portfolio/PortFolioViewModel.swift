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
//    private lazy var data = realm.objects(LikedCoinRealmSchema.self)
    private let networkService: NetworkServiceProvider
    private let alertManager = AlertManager.shared
    
    init(networkService: NetworkServiceProvider = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func transform(input: Input) -> Output {
        let result = BehaviorRelay(value: [CoinDetail]())
        let searchResult = BehaviorRelay(value: [CoinDetail]())
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<[CoinDetail]> in
                let realm = try! Realm()
                let coinIds = realm.objects(LikedCoinRealmSchema.self)
                return owner.networkService.callRequest(api: .coinList(coinIds.map {$0.id}), type: [CoinDetail].self)
                    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
                    .observe(on: MainScheduler.instance)
                    .catch { error in
                        owner.alertManager.showSimpleAlert(title: "에러", message: error.localizedDescription)
                        return Observable.just([])
                    }
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
    
}
