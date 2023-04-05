//
//  SettingsTableViewCell.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import SnapKit

class SettingsTableViewCell: UITableViewCell, ReusableView {
    
    private let settingsBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .AppCollors.cellColor
        return view
    }()
    
    private let titleImage: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .SFProRegular, sizeXS: 16)
        lbl.textColor = .black
        return lbl
    }()
    
    let arrowImage: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    var settingsModel: SettingType? {
        didSet {
            guard let model = settingsModel else { return }
            titleLabel.text = model.title
            titleImage.image = model.image
            arrowImage.image = model.imageArrow
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
        settingsBackgroundView.addSubview(titleImage)
        settingsBackgroundView.addSubview(titleLabel)
        settingsBackgroundView.addSubview(arrowImage)
        
        settingsBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleImage.snp.makeConstraints { make in
            make.top.equalTo(settingsBackgroundView.snp.top).offset(16)
            make.left.equalTo(settingsBackgroundView.snp.left).offset(16)
            make.bottom.equalTo(settingsBackgroundView.snp.bottom).offset(-16)
            make.right.equalTo(titleLabel.snp.left).offset(-8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(settingsBackgroundView.snp.top).offset(12)
            make.left.equalTo(settingsBackgroundView.snp.left).offset(40)
            make.bottom.equalTo(settingsBackgroundView.snp.bottom).offset(-12)
        }
        
        arrowImage.snp.makeConstraints { make in
            make.top.equalTo(settingsBackgroundView.snp.top).offset(12)
            make.right.equalTo(settingsBackgroundView.snp.right).offset(-16)
            make.bottom.equalTo(settingsBackgroundView.snp.bottom).offset(-12)
            make.width.equalTo(24)
        }
    }
    
}
