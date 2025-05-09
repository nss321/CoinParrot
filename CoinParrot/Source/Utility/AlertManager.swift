//
//  AlertManager.swift
//  CoinParrot
//
//  Created by BAE on 3/8/25.
//

import UIKit

final class AlertManager {
    static let shared = AlertManager()
    
    private init() { }
    
    private func root() -> UIViewController {
        UIApplication.shared.keyWindow!.rootViewController!
    }
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        root().present(alert, animated: true)
    }
    
    func showSimpleAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(ok)
        root().present(alert, animated: true)
    }
    
    func showDestructiveAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .destructive, handler: handler)
        let cancel = UIAlertAction(title: "취소", style: .default)
        alert.addAction(cancel)
        alert.addAction(ok)
        root().present(alert, animated: true)
    }
    
    func networkErrorAlert(type: NetworkError, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "네트워크 에러", message: type.message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(ok)
        root().present(alert, animated: true)
    }
}
