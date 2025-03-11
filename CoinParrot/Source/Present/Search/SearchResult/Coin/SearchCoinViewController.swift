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
    
    // TODO: 검색 결과 없을때 띄우기
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
    
    private(set) var viewModel = SearchCoinViewModel()
    
    override func bind() {
        let input = SearchCoinViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.result
            .drive(collectionView.rx.items(cellIdentifier: SearchCoinCollectionViewCell.id, cellType: SearchCoinCollectionViewCell.self))  { _, element, cell in
                cell.config(item: element)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(SearchCoin.self)
            .bind(with: self) { owner, coin in
                print(coin.id, "상세 정보를 불러 옵니다.")
                let viewModel = CoinDetailViewModel(coinId: coin.id)
                let vc = CoinDetailViewController(viewModel: viewModel)
                owner.navigationController?.pushViewController(vc, animated: true)
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
    
    override func configView() {
        navigationItem.searchController = UISearchController()
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
