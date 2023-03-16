//
//  SettingsTableViewCell.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 23.11.2022.
//

import UIKit

class SettingsTableViewCell: UITableViewCell, ReusableView {
    
    private let settingsBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .AppCollors.yeallow
        return view
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .MontsBold, sizeXS: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    var settingsModel: SettingType? {
        didSet {
            guard let model = settingsModel else { return }
            titleLabel.text = model.title.uppercased()
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
        contentView.addSubview(settingsBackgroundView)
        settingsBackgroundView.addSubview(titleLabel)
        
        settingsBackgroundView.topAnchor.constraint(equalTo: settingsBackgroundView.superview!.topAnchor, constant: 6).isActive = true
        settingsBackgroundView.leftAnchor.constraint(equalTo: settingsBackgroundView.superview!.leftAnchor, constant: 0).isActive = true
        settingsBackgroundView.rightAnchor.constraint(equalTo: settingsBackgroundView.superview!.rightAnchor).isActive = true
        settingsBackgroundView.bottomAnchor.constraint(equalTo: settingsBackgroundView.superview!.bottomAnchor, constant: -6).isActive = true
        settingsBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.leftAnchor.constraint(equalTo: titleLabel.superview!.leftAnchor, constant: 10).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleLabel.superview!.centerYAnchor).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
