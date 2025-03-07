//
//  BaseViewController.swift
//  CoinParrot
//
//  Created by BAE on 3/6/25.
//

import UIKit

import RxSwift

class BaseViewController: UIViewController, ViewConfig {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configLayout()
        configView()
        configBackgroundColor()
    }
    
    func bind() { }
    func configLayout() { }
    func configView() { }
}
