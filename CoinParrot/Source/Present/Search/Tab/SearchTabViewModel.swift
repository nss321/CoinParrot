//
//  SearchTabViewModel.swift
//  CoinParrot
//
//  Created by BAE on 3/9/25.
//

import RxSwift
import RxCocoa

final class SearchTabViewModel: ViewModel {
    struct Input {
        let searchButtonClicked: ControlEvent<Void>
        let searchBarText: ControlProperty<String?>
    }
    
    struct Output {
        let result: BehaviorRelay<[SearchCoin]>
        let errorNoti: Driver<String>
    }
    
    var disposeBag = DisposeBag()
    
    private let keyword: BehaviorRelay<String>
    
    lazy var navTitle = keyword.value
    
    var completion: ((String) -> Void)?
    
    init(keyword: String) {
        self.keyword = BehaviorRelay(value: keyword)
    }
    
    func transform(input: Input) -> Output {
        let result = BehaviorRelay(value: [SearchCoin]())
        let errorNoti = PublishRelay<String>()
        let isValid = PublishRelay<Void>()
        
        keyword
            .flatMap {
                NetworkService.shared.callRequest(api: .searchCoin($0), type: SearchCoinResponse.self)
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let value):
                    result.accept(value.coins)
                case .failure(let error):
                    print("코인 검색 네으워크 에러 발생: ", error)
                    errorNoti.accept(error.rawValue)
                }
            }
            .disposed(by: disposeBag)
        
        input.searchButtonClicked
            .throttle(.microseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchBarText.orEmpty)
            .map {
                KeywordValidation.checkValidation(text: $0)
            }
            .bind(with: self) { owner, valid in
                switch valid {
                case .empty:
                    AlertManager.shared.showSimpleAlert(title: "검색어", message: KeywordValidation.empty.message)
                case .valid:
                    if NetworkMonitor.shared.isConnected {
                        isValid.accept(())
                    } else {
                        AlertManager.shared.networkErrorAlert(type: .loss)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        isValid
            .withLatestFrom(input.searchBarText.orEmpty)
            .withUnretained(self)
            .map { owner, text -> String in
                owner.navTitle = text
                return text
            }
            .flatMap {
                NetworkService.shared.callRequest(api: .searchCoin($0), type: SearchCoinResponse.self)
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let value):
                    result.accept(value.coins)
                case .failure(let error):
                    print("코인 검색 네으워크 에러 발생: ", error)
                    errorNoti.accept(error.rawValue)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            result: result,
            errorNoti: errorNoti.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    func returnCompletion() {
        completion!(navTitle)
    }
}
