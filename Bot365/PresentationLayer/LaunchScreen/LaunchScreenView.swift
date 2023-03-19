//
//  LaunchScreenView.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import SnapKit

class LaunchScreenView: UIView {
    
    
    private let botImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "appLogo")
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .AppCollors.backgroundGreen
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(botImageView)
        
        botImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

    }
}
