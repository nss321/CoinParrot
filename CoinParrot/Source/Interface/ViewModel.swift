//
//  ViewModel.swift
//  CoinParrot
//
//  Created by BAE on 3/6/25.
//

import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
    var disposeBag: DisposeBag { get }
}
