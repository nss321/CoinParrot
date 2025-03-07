//
//  MarketViewController.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

import SnapKit
import RxSwift

final class MarketViewController:  BaseViewController {
    
    private let header = MarketHeaderView()
    
    private let viewModel = MarkerViewModel()
    
    override func bind() {
        let input = MarkerViewModel.Input(
            sortByPriceButtonTap: header.sortByPriceButton.rx.tap,
            sortByChangesButtonTap: header.sortByChangesButton.rx.tap,
            sortByAmountButtonTap: header.sortByAmountButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.output
            .drive(with: self) { owner, _ in
                print("탭")
            }
            .disposed(by: disposeBag)
        
        
    }
    
    override func configLayout() {
        [header].forEach { view.addSubview($0) }
        
        header.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(32)
        }
    }
    
    override func configView() {
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: UILabel.marketNavLabel()), animated: false)
    }
    
}
