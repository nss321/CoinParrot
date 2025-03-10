//
//  SortButton.swift
//  CoinParrot
//
//  Created by BAE on 3/7/25.
//

import UIKit

import SnapKit

final class SortButton: UIButton, ViewConfig {
    
    var type: SortType?
    
    private let title = {
        let label = UILabel()
        label.font = .boldPrimary()
        label.textColor = .coinParrotNavy
        return label
    }()
    
    private let upIndicator = {
        let view = UIImageView()
        view.image = UIImage(systemName: "arrowtriangle.up.fill")?.withTintColor(.coinParrotGray, renderingMode: .alwaysOriginal)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let downIndicator = {
        let view = UIImageView()
        view.image = UIImage(systemName: "arrowtriangle.down.fill")?.withTintColor(.coinParrotGray, renderingMode: .alwaysOriginal)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let labelHeight = ("1" as NSString).size(withAttributes: [ .font : UIFont.boldSystemFont(ofSize: 12)]).height
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configLayout()
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, type: SortType) {
        self.init()
        self.title.text = title
        self.type = type
    }
    
    func configLayout() {
        addSubview(title)
        addSubview(upIndicator)
        addSubview(downIndicator)
            
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(upIndicator.snp.leading).inset(4)
        }
        
        upIndicator.snp.makeConstraints {
            $0.top.equalTo(title.snp.top).offset(-3)
            $0.height.equalTo(12)
            $0.trailing.equalToSuperview()
        }
        
        downIndicator.snp.makeConstraints {
            $0.bottom.equalTo(title.snp.bottom).offset(3)
            $0.height.equalTo(12)
            $0.trailing.equalToSuperview()
        }
    }
    
    func configView() {
    }
    
}
