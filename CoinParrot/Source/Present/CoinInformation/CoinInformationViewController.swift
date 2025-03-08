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
    var items: [Trending]
}

extension TrendingHeader: SectionModelType {
    typealias Item = Trending
    
    init(original: TrendingHeader, items: [Trending]) {
        self = original
        self.items = items
    }
}

enum Trending {
    case coin(TrendingCoinDetails)
    case nft(TrendingNFTItem)
}

final class CoinInformationViewController: BaseViewController {
    
    // MARK: Property
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
        view.register(TrendingCoinCollectionViewCell.self, forCellWithReuseIdentifier: TrendingCoinCollectionViewCell.id)
        view.register(TrendingNFTCollectionViewCell.self, forCellWithReuseIdentifier: TrendingNFTCollectionViewCell.id)
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<TrendingHeader> { _, collectionView, indexPath, item in
        switch item {
        case .coin(let trendingCoin):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCoinCollectionViewCell.id, for: indexPath) as! TrendingCoinCollectionViewCell
            cell.config(item: trendingCoin, index: indexPath.item+1)
            return cell
        case .nft(let trendingNft):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingNFTCollectionViewCell.id, for: indexPath) as! TrendingNFTCollectionViewCell
            cell.config(item: trendingNft)
            return cell
        }
    } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrendingCollectionViewHeader.id, for: indexPath) as! TrendingCollectionViewHeader
        header.config(title: dataSource.sectionModels[indexPath.section].title, subTitle: dataSource.sectionModels[indexPath.section].subTitle)
        return header
    }
    
    private let viewModel = CoinInformationViewModel()
    private let sectionSubject = BehaviorRelay(value: [TrendingHeader]())

    
    // MARK: Method
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
        
        collectionView.rx.modelSelected(Trending.self)
            .bind(with: self) { owner, trending in
                switch trending {
                case .coin(let coin):
                    print(coin)
                case .nft(let nft):
                    print(nft)
                }
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

    // MARK: Extension
private extension CoinInformationViewController {
    func clayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            let section: NSCollectionLayoutSection
            
            if sectionIndex == 0 {
                // 인기 검색어
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
                // 인기 NFT
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(72), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                /// cellWidth + spacing + margin
                let groupWidth = 72 * 7 + 6 * self!.smallMargin + 2 * self!.largeMargin
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(CGFloat(groupWidth)), heightDimension: .absolute(132))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(CGFloat(self!.smallMargin))
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: CGFloat(self!.largeMargin), bottom: 0, trailing: CGFloat(self!.largeMargin))
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
            }
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        return layout
    }
    
}
