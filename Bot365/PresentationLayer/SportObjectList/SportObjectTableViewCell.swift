//
//  SportObjectTableViewCell.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit

class SportObjectTableViewCell: UITableViewCell, ReusableView {

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .MontsBold, sizeXS: 14)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .MontsRegular, sizeXS: 10)
        lbl.textColor = .white
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let contentBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let sportObjectImageView: UIImageView = {
        let iv = UIImageView()
        iv.setContentHuggingPriority(.required, for: .horizontal)
        return iv
    }()
    
    var object: SportObject? {
        didSet {
            guard let model = object else { return }
            titleLabel.text = model.name
            subtitleLabel.text = model.address
            sportObjectImageView.image = UIImage(named: model.type.sportObjectListImage)
            contentBackgroundView.backgroundColor = model.type.backgroundColor
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(contentBackgroundView)
        contentBackgroundView.addSubview(sportObjectImageView)
        contentBackgroundView.addSubview(titleLabel)
        contentBackgroundView.addSubview(subtitleLabel)
        
        contentBackgroundView.topAnchor.constraint(equalTo: contentBackgroundView.superview!.topAnchor, constant: 5).isActive = true
        contentBackgroundView.heightAnchor.constraint(equalToConstant: CGFloat(100).dp).isActive = true
        contentBackgroundView.leftAnchor.constraint(equalTo: contentBackgroundView.superview!.leftAnchor).isActive = true
        contentBackgroundView.rightAnchor.constraint(equalTo: contentBackgroundView.superview!.rightAnchor).isActive = true
        contentBackgroundView.bottomAnchor.constraint(equalTo: contentBackgroundView.superview!.bottomAnchor, constant: -5).isActive = true
        contentBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: titleLabel.superview!.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: titleLabel.superview!.leftAnchor, constant: 21).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: sportObjectImageView.leftAnchor, constant: -25).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: sportObjectImageView.leftAnchor, constant: -25).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.superview!.bottomAnchor, constant: -16).isActive = true
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sportObjectImageView.centerYAnchor.constraint(equalTo: sportObjectImageView.superview!.centerYAnchor).isActive = true
        sportObjectImageView.rightAnchor.constraint(equalTo: sportObjectImageView.superview!.rightAnchor).isActive = true
        sportObjectImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
