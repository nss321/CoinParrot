//
//  ViewController.swift
//  CoinParrot
//
//  Created by BAE on 3/6/25.
//

import UIKit

import RealmSwift

final class CoinParrotTabBarController: UITabBarController {
    
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabBar()
        setupTabbarAppearance()
        print(realm.configuration.fileURL ?? "cannot find realm path")
    }
    
    func configTabBar() {
        let firstVC = UINavigationController(rootViewController: MarketViewController())
        firstVC.tabBarItem.image = UIImage(systemName: "chart.line.uptrend.xyaxis")
        firstVC.tabBarItem.title = "거래소"
        
        let secondVC = UINavigationController(rootViewController: CoinInformationViewController())
        secondVC.tabBarItem.image = UIImage(systemName: "chart.bar.fill")
        secondVC.tabBarItem.title = "코인정보"
        
        let thirdVC = UINavigationController(rootViewController: PortFolioViewController())
        thirdVC.tabBarItem.image = UIImage(systemName: "star")
        thirdVC.tabBarItem.title = "포트폴리오"
        
        setViewControllers([firstVC, secondVC, thirdVC], animated: true)
    }
    
    func setupTabbarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .systemBackground
        appearance.selectionIndicatorTintColor = .coinParrotNavy
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = UITabBar.appearance().standardAppearance
    }
    
}
