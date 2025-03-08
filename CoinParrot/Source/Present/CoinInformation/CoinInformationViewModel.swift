//
//  CoinInformationViewModel.swift
//  CoinParrot
//
//  Created by BAE on 3/8/25.
//

import RxSwift
import RxCocoa

final class CoinInformationViewModel: ViewModel {
    
    /// Validate Conditions. If needs extra condtions, add case to this.
    private enum KeywordValidation: String {
        case empty
//        case short
        case valid
        
        var message: String {
            switch self {
            case .empty:
                return "공백은 입력할 수 없습니다."
//            case .short:
//                return "검색어는 2글자 이상 입력해주세요."
            case .valid:
                return "valid"
            }
        }
    }
    
    struct Input {
        let searchButtonClicked: ControlEvent<Void>
        let searchBarText: ControlProperty<String?>
    }
    
    struct Output {
        let output: Driver<String>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let test = PublishRelay<String>()
        let isValid = PublishRelay<Void>()
        
        input.searchButtonClicked
            .throttle(.microseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchBarText.orEmpty)
            .withUnretained(self)
            .compactMap { owner, text in
                owner.checkValidation(text: text)
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
        
        return Output(
            output: test.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    private func checkValidation(text: String) -> KeywordValidation {
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        if trimmedText == "" {
            return KeywordValidation.empty
        }
        
        // if you need length constration, use this.
//        if text.count < 2 {
//            return KeywordValidation.short
//        }
        
        return KeywordValidation.valid
    }
}
