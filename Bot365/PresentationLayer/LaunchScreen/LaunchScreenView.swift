//
//  LaunchScreenView.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 29.11.2022.
//

import UIKit

class LaunchScreenView: UIView {
    
    private let circleImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Ellipse")
        return iv
    }()
    
    private let nacionaleImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "nacional")
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .AppCollors.backgroundBlue
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(nacionaleImageView)
        addSubview(circleImageView)
        
        nacionaleImageView.topAnchor.constraint(equalTo: nacionaleImageView.superview!.safeTopAnchor, constant: 412).isActive = true
        nacionaleImageView.centerXAnchor.constraint(equalTo: nacionaleImageView.superview!.centerXAnchor).isActive = true
        nacionaleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        circleImageView.widthAnchor.constraint(equalToConstant: 88).isActive = true
        circleImageView.heightAnchor.constraint(equalToConstant: 88).isActive = true
        circleImageView.leftAnchor.constraint(equalTo: nacionaleImageView.leftAnchor).isActive = true
        circleImageView.bottomAnchor.constraint(equalTo: nacionaleImageView.topAnchor).isActive = true
        circleImageView.translatesAutoresizingMaskIntoConstraints = false
    }
}
