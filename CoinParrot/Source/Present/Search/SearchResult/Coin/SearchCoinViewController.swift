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
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
    
    deinit {
        print("searchview deinit")
    }
    
    override func bind() {
        let input = SearchCoinViewModel.Input(
            collectionViewModelSelected: collectionView.rx.modelSelected(SearchCoin.self)
        )
        let output = viewModel.transform(input: input)
        
        output.result
            .drive(
                collectionView.rx.items(cellIdentifier: SearchCoinCollectionViewCell.id, cellType: SearchCoinCollectionViewCell.self))  { _, element, cell in
                cell.config(item: element)
            }
            .disposed(by: disposeBag)
        
        output.selectedModel
            .drive(with: self) { owner, coin in
                owner.collectionView.isHidden = false
                owner.label.isHidden = true
                print(coin.id, "상세 정보를 불러 옵니다.")
                let viewModel = CoinDetailViewModel(coinId: coin.id)
                let vc = CoinDetailViewController(viewModel: viewModel)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        output.isEmpty
            .drive(with: self) { owner, value in
                owner.collectionView.isHidden = value
                owner.label.isHidden = !value
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
        navigationItem.backButtonTitle = ""
        navigationItem.searchController = UISearchController()
    }
}

private extension SearchCoinViewController {
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: appDelegate.screenWidth, height: 72)
        layout.minimumLineSpacing = 0
        return layout
    }
}
