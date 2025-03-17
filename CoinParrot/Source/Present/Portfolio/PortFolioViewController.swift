//
//  PortFolioViewController.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

final class PortFolioViewController: BaseViewController {
    
    private let label = {
        let label = UILabel()
        label.text = "검색 결과가 없습니다."
        label.font = .boldPrimary()
        label.textColor = .coinParrotNavy
        label.isHidden = true
        return label
    }()
    
    override func bind() {
        
    }
    
    override func configLayout() {
        
    }
    
    override func configView() {
        
    }
    
}
