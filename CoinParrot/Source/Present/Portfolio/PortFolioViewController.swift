//
//  PortFolioViewController.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

import SnapKit

final class PortFolioViewController: BaseViewController {

    enum Section {
        case main
    }
    
    typealias Item = SearchCoin
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private let label = {
        let label = UILabel()
        label.text = "검색 결과가 없습니다."
        label.font = .boldPrimary()
        label.textColor = .coinParrotNavy
        label.isHidden = true
        return label
    }()
    
    private lazy var searchBar = {
        let view = UISearchBar()
        view.searchTextField.font = .systemFont(ofSize: 14)
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.coinParrotGray.cgColor
        view.layer.borderWidth = 1
        view.searchTextField.backgroundColor = .white
        view.backgroundImage = UIImage()
        view.delegate = self
        return view
    }()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    override func bind() {
        
    }
    
    override func configLayout() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Margin.small)
            $0.horizontalEdges.equalToSuperview().inset(Margin.medium)
            $0.height.equalTo(32)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(Margin.small)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: UILabel.portFolioLabel()), animated: false)
        
        let registration = UICollectionView.CellRegistration<SearchCoinCollectionViewCell, Item>  { cell, indexPath, itemIdentifier in
            cell.config(item: itemIdentifier)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
        })
        
        updateSnapshot()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
}

private extension PortFolioViewController {
    func layout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/12))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(mockSearchCoin, toSection: .main)
        dataSource.apply(snapshot)
    }
    
    func performQuery(with filter: String?) {
        let filtered = mockSearchCoin.filter { $0.name.hasPrefix(filter ?? "") }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filtered)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension PortFolioViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(#function)
        let text = searchController.searchBar.text
        performQuery(with: text)
    }
}

extension PortFolioViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
        performQuery(with: searchText)
    }
}
