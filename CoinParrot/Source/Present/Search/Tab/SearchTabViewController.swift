//
//  SearchViewController.swift
//  CoinParrot
//
//  Created by BAE on 3/8/25.
//

import UIKit

import Pageboy
import RxSwift
import RxCocoa
import SnapKit
import Tabman

final class SearchTabViewController: TabmanViewController, ViewConfig {
    
    private lazy var searchBar = {
        let view = UISearchBar()
        view.text = viewModel.navTitle
        view.searchTextField.font = .systemFont(ofSize: 14)
        view.frame = CGRect(x: 0, y: 0, width: Int(ScreenSize.screenWidth), height: 0)
        view.searchTextField.leftViewMode = .always
        view.searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.searchTextPositionAdjustment = .init(horizontal: -CGFloat(Margin.small), vertical: 0)
        view.searchTextField.backgroundColor = .white
        view.searchTextField.clearButtonMode = .never
        return view
    }()
    
    private let coinViewController = SearchCoinViewController()
    private let nftViewController = SearchNFTViewController()
    private let marketViewController = SearchMarketViewController()
    
    private(set) var viewModel: SearchTabViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: SearchTabViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configTabman()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.returnCompletion()
    }
    
    func bind() {
        let input = SearchTabViewModel.Input(
            searchButtonClicked: searchBar.rx.searchButtonClicked,
            searchBarText: searchBar.rx.text
        )
        let output = viewModel.transform(input: input)
        
        
        output.result
            .bind(to: coinViewController.viewModel.result)
            .disposed(by: disposeBag)
        
        output.errorNoti
            .drive(with: self) { owner, message in
                AlertManager.shared.showSimpleAlert(title: "에러", message: message)
            }
            .disposed(by: disposeBag)
    }
    
    func configLayout() { }
    
    func configView() {
        view.backgroundColor = .white
        self.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    private func configTabman() {
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .flat(color: .white)
        bar.layout.transitionStyle = .snap
        bar.layout.contentMode = .fit
        bar.tintColor = .coinParrotNavy
        
        bar.buttons.customize { button in
            button.tintColor = .coinParrotGray
            button.selectedTintColor = .coinParrotNavy
            button.font = .systemFont(ofSize: 14)
            button.selectedFont = .boldSystemFont(ofSize: 14)
        }
        
        bar.indicator.weight = .light

        addBar(bar, dataSource: self, at: .top)
        
        bar.layer.addEdgeBorder([.bottom], color: .coinParrotGray, width: 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension SearchTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        3
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        [coinViewController, nftViewController, marketViewController][index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        nil
    }
    
    func barItem(for bar: any Tabman.TMBar, at index: Int) -> any Tabman.TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "코인")
        case 1:
            return TMBarItem(title: "NFT")
        case 2:
            return TMBarItem(title: "거래소")
        default:
            return TMBarItem(title: "")
        }
    }
}
