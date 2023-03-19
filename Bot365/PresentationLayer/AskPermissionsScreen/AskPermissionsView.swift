//
//  AskLocationView.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import SnapKit

class AskPermissionsView: UIView {
    
    enum Constants {
        static let attention: String = "Attention!"
        static let allow: String = "Allow"
        static let skip: String = "No, Thank you"
        static let cornerRaidus: CGFloat = 15
        static let allowCornerRaidus: CGFloat = 20
    }
    
    let ellipseView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Ellipse")
        return view
    }()
    
    let pushIconView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    let causeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.setFont(fontName: .GilroyMedium, sizeXS: 24)
        return lbl
    }()
    
    let secondCauseLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.setFont(fontName: .GilroyMedium, sizeXS: 16)
        return lbl
    }()
    
    private let allowButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(Constants.allow, for: .normal)
        btn.setTitleColor(.yellow, for: .normal)
        btn.backgroundColor = .AppCollors.backgroundGreen
        btn.layer.cornerRadius = Constants.allowCornerRaidus
        btn.titleLabel?.setFont(fontName: .MontsBold, sizeXS: 18)
        
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.background.backgroundColor = .AppCollors.backgroundGreen
            config.background.cornerRadius = Constants.allowCornerRaidus
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(font: .MontsBold, size: 18)
                return outgoing
            }
            btn.configuration = config
        }
        btn.addTarget(nil, action: #selector(AskPermissionsViewController.allowTapped), for: .touchUpInside)
        return btn
    }()
    
    let skipButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(.AppCollors.backgroundGreen, for: .normal)
        btn.titleLabel?.setFont(fontName: .GilroyMedium, sizeXS: 16)
        btn.addTarget(nil, action: #selector(AskPermissionsViewController.skipTapped), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        
        addSubview(ellipseView)
        ellipseView.addSubview(pushIconView)
        addSubview(causeLabel)
        addSubview(secondCauseLabel)
        addSubview(allowButton)
        addSubview(skipButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        ellipseView.snp.makeConstraints { make in
            make.centerX.equalTo(allowButton.snp.centerX)
            make.height.equalTo(148)
            make.width.equalTo(148)
            make.top.equalTo(self.snp.top).offset(160)
        }
        
        pushIconView.snp.makeConstraints { make in
            make.top.equalTo(ellipseView.snp.top).offset(48)
            make.right.equalTo(ellipseView.snp.right).offset(-48)
            make.left.equalTo(ellipseView.snp.left).offset(48)
            make.bottom.equalTo(ellipseView.snp.bottom).offset(-48)
        }
        
        causeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(allowButton.snp.centerX)
            make.height.equalTo(64)
            make.width.equalTo(192)
            make.top.equalTo(ellipseView.snp.bottom).offset(24)
        }
        
        secondCauseLabel.snp.makeConstraints { make in
            make.centerX.equalTo(allowButton.snp.centerX)
            make.height.equalTo(48)
            make.width.equalTo(224)
            make.top.equalTo(causeLabel.snp.bottom).offset(8)
        }
        
        allowButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).inset(32)
            make.left.equalTo(self.snp.left).offset(32)
            make.right.equalTo(self.snp.right).inset(32)
            make.height.equalTo(48)
        }
        
        skipButton.snp.makeConstraints { make in
            make.centerX.equalTo(allowButton.snp.centerX)
            make.height.equalTo(24)
            make.width.equalTo(109)
            make.bottom.equalTo(allowButton.snp.top).offset(-24)
        }
        
    }
    
}
