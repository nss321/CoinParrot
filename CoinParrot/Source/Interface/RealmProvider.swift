//
//  RealmProvider.swift
//  CoinParrot
//
//  Created by BAE on 3/20/25.
//

import RealmSwift

protocol RealmProvider {
    func objects<T: Object>(_ type: T.Type) -> Results<T>
}

extension Realm: RealmProvider {
    
}
