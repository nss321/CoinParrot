//
//  KeyboardToolbar.swift
//  CoinParrot
//
//  Created by BAE on 3/20/25.
//

import UIKit

final class KeyboardToolbar: UIToolbar {
    private let dismissButton = UIBarButtonItem(
        image: UIImage(systemName: "keyboard.chevron.compact.down")?.withTintColor(.coinParrotGray, renderingMode: .alwaysOriginal)
    )
    
    private let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sizeToFit()
        setItems([flexibleSpaceButton, dismissButton], animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(action: UIAction) {
        print(action)
        self.dismissButton.primaryAction = action
        super.init()
        print(#function, "done button init", dismissButton.primaryAction)
    }
}
