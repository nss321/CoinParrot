//
//  MarketViewController.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class MarketViewController:  BaseViewController {
    
    private let header = MarketHeaderView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private let viewModel = MarkerViewModel()
    
    override func bind() {
        let input = MarkerViewModel.Input(
            sortByPriceButtonTap: header.sortByPriceButton.rx.tap,
            sortByChangesButtonTap: header.sortByChangesButton.rx.tap,
            sortByAmountButtonTap: header.sortByAmountButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.output
            .drive(with: self) { owner, state in
                print(state)
                // 버튼 UI 변경
                
            }
            .disposed(by: disposeBag)
        
        
        output.mockDataSource
            .drive(collectionView.rx.items(cellIdentifier: MarketCollectionViewCell.id, cellType: MarketCollectionViewCell.self)) { _, element, cell in
                cell.config(item: element)
            }
            .disposed(by: disposeBag)
        
        
    }
    
    override func configLayout() {
        [header, collectionView].forEach { view.addSubview($0) }
        
        header.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: UILabel.marketNavLabel()), animated: false)
        collectionView.register(MarketCollectionViewCell.self, forCellWithReuseIdentifier: MarketCollectionViewCell.id)
        hasDecimalPlaces(number: 29822485605.47842841)
        print(NumberFormatManager.shared.roundedNumeric(number: 806.0000000))
    }
    
    private func hasDecimalPlaces(number: Double) {
        let number = String(number)
        let pointIndex = number.firstIndex(of: ".")!
        print(number[pointIndex...])
    }
}

private extension MarketViewController {
    func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth, height: 44)
        layout.minimumLineSpacing = 0
        return layout
    }
    
}
