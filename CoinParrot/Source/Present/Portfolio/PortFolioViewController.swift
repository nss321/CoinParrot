//
//  PortFolioViewController.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class PortFolioViewController: BaseViewController {

    enum Section {
        case main
    }
    
    typealias Item = SearchCoin
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private let viewModel: PortFolioViewModel
    
    private var viewDidLoadTrigger = PublishRelay<Void>()
    
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
        return view
    }()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    init(viewModel: PortFolioViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDidLoadTrigger.accept(())
        // TODO: 코인 정보 탭 - 트렌딩 코인 - 코인 상세에서 좋아요 상태인 코인을 포트폴리오 탭에서 삭제해도 코인정보 탭 내비게이션의 좋아요 버튼은 리프레쉬 되지 않는 문제 해결해야함.
    }
    
    override func bind() {
        let input = PortFolioViewModel.Input(
            viewDidLoadEvent: viewDidLoadTrigger,
            searchKeyword: searchBar.rx.text
        )
        let output = viewModel.transform(input: input)
        
        output.likedCoins
            .drive(with: self) { owner, item in
                owner.updateSnapshot(with: item)
            }
            .disposed(by: disposeBag)
        
        output.searchResult
            .drive(with: self) { owner, item in
                owner.updateSnapshot(with: item)
            }
            .disposed(by: disposeBag)
        
        output.error
            .drive { error in
                AlertManager.shared.showSimpleAlert(title: "네트워크 오류", message: error.message)
            }
            .disposed(by: disposeBag)

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
    
    func updateSnapshot(with: [CoinDetail]) {
        let dto = with.map {
            SearchCoin(id: $0.id, name: $0.name, apiSymbol: "", symbol: $0.symbol.uppercased(), marketCapRank: $0.marketCapRank, thumb: $0.image, large: "")
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(dto, toSection: .main)
        dataSource.apply(snapshot)
    }

}
