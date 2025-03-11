//
//  CustomLikeButton.swift
//  CoinParrot
//
//  Created by BAE on 3/11/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Toast

final class StarButton: UIButton {

    var viewModel: StarButtonViewModel!
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration = .starButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(viewModel: StarButtonViewModel) {
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        let buttonConfig = Observable.just(())
        
        let input = StarButtonViewModel.Input(
            buttonConfig: buttonConfig,
            buttonTap: rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.isStarred
            .drive(with: self) { owner, isLiked in
                if isLiked {
                    owner.configuration?.image = UIImage(systemName: "star.fill")?.withTintColor(.coinParrotNavy, renderingMode: .alwaysOriginal)
                } else {
                    owner.configuration?.image = UIImage(systemName: "star")?.withTintColor(.coinParrotNavy, renderingMode: .alwaysOriginal)
                }
            }
            .disposed(by: disposeBag)
        
        output.toastMessage
            .drive(with: self) { owner, message in
                owner.root().view.makeToast(message, duration: 1.5)
            }
            .disposed(by: disposeBag)
    }
}

extension StarButton {
    private func root() -> UIViewController {
        UIApplication.shared.keyWindow!.rootViewController!
    }
}
