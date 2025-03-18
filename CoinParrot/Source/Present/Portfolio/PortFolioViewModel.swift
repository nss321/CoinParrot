//
//  PortFolioViewModel.swift
//  CoinParrot
//
//  Created by BAE on 3/17/25.
//

import RxSwift
import RxCocoa

final class PortFolioViewModel: ViewModel {
    
    struct Input {
        let viewDidLoadEvent: BehaviorRelay<Void>
        let searchKeyword: ControlProperty<String?>
    }
    
    struct Output {
        let likedCoins: Driver<[CoinDetail]>
        let searchResult: Driver<[CoinDetail]>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let result = BehaviorRelay(value: [CoinDetail]())
        let searchResult = BehaviorRelay(value: [CoinDetail]())
        
        input.viewDidLoadEvent
            .flatMap {
                NetworkService.shared.callRequest(api: .coinList(["pepe", "bitcoin"]), type: [CoinDetail].self)
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
