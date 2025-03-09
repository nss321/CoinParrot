//
//  SearchCoinViewController.swift
//  CoinParrot
//
//  Created by BAE on 3/8/25.
//

import UIKit

import RxCocoa
import SnapKit

final class SearchCoinViewController: BaseViewController {
    
    private let label = {
        let label = UILabel()
        label.text = "검색 결과가 없습니다."
        label.font = .boldPrimary()
        label.textColor = .coinParrotNavy
        label.isHidden = true
        return label
    }()
    
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout())
        view.register(SearchCoinCollectionViewCell.self, forCellWithReuseIdentifier: SearchCoinCollectionViewCell.id)
        return view
    }()
    
    private let viewModel = SearchCoinViewModel()
    
    override func bind() {
        let input = SearchCoinViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.mockDataSource
            .drive(collectionView.rx.items(cellIdentifier: SearchCoinCollectionViewCell.id, cellType: SearchCoinCollectionViewCell.self))  { _, element, cell in
                cell.config(item: element)
            }
            .disposed(by: disposeBag)
    }
    
    override func configLayout() {
        view.addSubview(label)
        view.addSubview(collectionView)
        
        label.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

private extension SearchCoinViewController {
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth, height: 72)
        layout.minimumLineSpacing = 0
        return layout
    }
}
