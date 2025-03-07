//
//  CoinInformationViewController.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

final class CoinInformationViewController: BaseViewController {
 
    override func bind() {
        
    }
    
    override func configLayout() {
        
    }
    
    override func configView() {
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: UILabel.informationNavLabel()), animated: false)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
}
