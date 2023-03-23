//
//  InformationView.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit

class InformationView: UIView {
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .MontsBlack, sizeXS: 14)
        lbl.textColor = .AppCollors.darkBlue
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .MontsRegular, sizeXS: 10)
        lbl.textColor = .AppCollors.darkBlue
        lbl.numberOfLines = 0
        return lbl
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.AppCollors.yeallow.cgColor
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    private func setupView() {
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: titleLabel.superview!.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: titleLabel.superview!.leftAnchor, constant: 21).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: titleLabel.superview!.rightAnchor, constant: -21).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 11).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
