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
    private var realm = try! Realm()
    private lazy var data = realm.objects(LikedCoinRealmSchema.self)
    
    func transform(input: Input) -> Output {
        let result = BehaviorRelay(value: [CoinDetail]())
        let searchResult = BehaviorRelay(value: [CoinDetail]())
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .flatMap { owner, _ in
                NetworkService.shared.callRequest(api: .coinList(owner.data.map{ $0.id }), type: [CoinDetail].self)
            }
            .subscribe(with: self) { owner, items in
                result.accept(items)
                print(items, "item")
            } onError: { owner, error in
                AlertManager.shared.showSimpleAlert(title: "에러", message: error.localizedDescription)
            }
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
