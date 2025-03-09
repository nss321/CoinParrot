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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
