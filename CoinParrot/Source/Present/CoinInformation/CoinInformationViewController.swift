//
//  CoinInformationViewController.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class CoinInformationViewController: BaseViewController {
    
    private lazy var searchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "검색어를 입력해주세요.",
            attributes: [
                .foregroundColor: UIColor.coinParrotGray,
                .font : UIFont.systemFont(ofSize: 14)
            ]
        )
        searchBar.layer.cornerRadius = 22
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.coinParrotGray.cgColor
        searchBar.searchTextField.backgroundColor = .white
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout())
//        view.register(<#T##AnyClass?#>, forCellWithReuseIdentifier: <#T##String#>)
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.red.cgColor
        return view
    }()
    
    private let viewModel = CoinInformationViewModel()
 
    override func bind() {
        let input = CoinInformationViewModel.Input(
            searchButtonClicked: searchBar.rx.searchButtonClicked,
            searchBarText: searchBar.rx.text
        )
        
        let output = viewModel.transform(input: input)
        
        output.output
            .drive(with: self) { owner, text in
                print(text)
                let vc = SearchRootViewController()
                owner.navigationItem.backButtonTitle = text
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func configLayout() {
        [searchBar, collectionView].forEach { view.addSubview($0) }
    
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(largeMargin)
            $0.horizontalEdges.equalToSuperview().inset(largeMargin)
            $0.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(largeMargin)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: UILabel.informationNavLabel()), animated: false)
    }
    
}

private extension CoinInformationViewController {
    func layout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}
