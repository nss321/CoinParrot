//
//  CoinInformationViewController.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

import RxDataSources
import RxSwift
import RxCocoa
import SnapKit

struct TrendingHeader {
    let title: String
    let subTitle: String?
    var items: [TrendingCoinDetails]
}

extension TrendingHeader: SectionModelType {
    typealias Item = TrendingCoinDetails
    
    init(original: TrendingHeader, items: [TrendingCoinDetails]) {
        self = original
        self.items = items
    }
}

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
        let view = UICollectionView(frame: .zero, collectionViewLayout: clayout())
        view.register(TrendingCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrendingCollectionViewHeader.id)
        view.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: TrendingCollectionViewCell.id)
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.red.cgColor
        return view
    }()
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<TrendingHeader> { _, collectionView, indexPath, item in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCollectionViewCell.id, for: indexPath) as! TrendingCollectionViewCell
        cell.config(item: item, index: indexPath.item + 1)
        return cell
    } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrendingCollectionViewHeader.id, for: indexPath) as! TrendingCollectionViewHeader
        header.config(title: dataSource.sectionModels[indexPath.section].title, subTitle: dataSource.sectionModels[indexPath.section].subTitle)
        return header
    }
    
    private let viewModel = CoinInformationViewModel()
    private let sectionSubject = BehaviorRelay(value: [TrendingHeader]())

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
        
        output.mockDataSource
            .drive(collectionView.rx.items(dataSource: dataSource))
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
    func clayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section: NSCollectionLayoutSection
            
            if sectionIndex == 0 {
                // 인기 검색어 섹션
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/7))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(44 * 7))
                let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, repeatingSubitem: item, count: 7)
                verticalGroup.interItemSpacing = .fixed(0)
                
                let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44 * 7))
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, repeatingSubitem: verticalGroup, count: 2)
                horizontalGroup.interItemSpacing = .fixed(0)

                section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .none

            } else {
                // 인기 NFT 섹션
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                section = NSCollectionLayoutSection(group: group)
            }
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        return layout
    }
    
    func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: screenWidth/2,
            height: 44
        )
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }
}
