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
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let result = input.viewDidLoadEvent
            .flatMap {
                NetworkService.shared.callRequest(api: .coinList(["pepe", "bitcoin"]), type: [CoinDetail].self)
                    .asObservable()
                    .catchAndReturn([])
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(likedCoins: result)
    }
    
}
