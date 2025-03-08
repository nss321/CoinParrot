//
//  SearchViewController.swift
//  CoinParrot
//
//  Created by BAE on 3/8/25.
//

import UIKit

import Pageboy
import SnapKit
import Tabman

final class SearchRootViewController: TabmanViewController {
        
    private var viewControllers = [ SearchCoinViewController(),SearchNFTViewController(),SearchMarketViewController() ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabman()
    }
    
    private func configView() {
        view.backgroundColor = .white
        self.dataSource = self
        
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
}

extension SearchRootViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
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
