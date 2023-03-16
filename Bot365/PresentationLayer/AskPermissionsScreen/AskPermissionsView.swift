//
//  AskLocationView.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 22.11.2022.
//

import UIKit

class AskPermissionsView: UIView {
    
    enum Constants {
        static let attention: String = "Attention!"
        static let allow: String = "Allow"
        static let skip: String = "Skip"
        static let cornerRaidus: CGFloat = 15
        static let allowCornerRaidus: CGFloat = 20
    }
    
    private let attentionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = Constants.attention.uppercased()
        lbl.textColor = .AppCollors.darkBlue
        lbl.setFont(fontName: .MontsBlack, sizeXS: 18)
        return lbl
    }()
    
    private let attentionBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .AppCollors.yeallow
        view.layer.cornerRadius = Constants.cornerRaidus
        return view
    }()
    
    let causeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.setFont(fontName: .GilroyMedium, sizeXS: 14)
        return lbl
    }()

    private let allowButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(Constants.allow, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = Constants.allowCornerRaidus
        btn.titleLabel?.setFont(fontName: .MontsBold, sizeXS: 18)
        
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.background.backgroundColor = UIColor.white
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
    
    private let skipButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(Constants.skip, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.setFont(fontName: .GilroyMedium, sizeXS: 14)
        btn.addTarget(nil, action: #selector(AskPermissionsViewController.skipTapped), for: .touchUpInside)
        btn.titleLabel?.underline()
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
        backgroundColor = UIColor.AppCollors.backgroundBlue
        
        addSubview(attentionBackgroundView)
        attentionBackgroundView.addSubview(attentionLabel)
        addSubview(causeLabel)
        addSubview(allowButton)
        addSubview(skipButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        allowButton.widthAnchor.constraint(equalToConstant: CGFloat(271).dp).isActive = true
        allowButton.heightAnchor.constraint(equalToConstant: CGFloat(60).dp).isActive = true
        allowButton.centerXAnchor.constraint(equalTo: allowButton.superview!.centerXAnchor).isActive = true
        allowButton.bottomAnchor.constraint(equalTo: allowButton.superview!.bottomAnchor, constant: -184).isActive = true
        allowButton.translatesAutoresizingMaskIntoConstraints = false
        
        skipButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        skipButton.centerXAnchor.constraint(equalTo: skipButton.superview!.centerXAnchor).isActive = true
        skipButton.topAnchor.constraint(equalTo: allowButton.bottomAnchor).isActive = true
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        
        attentionBackgroundView.topAnchor.constraint(equalTo: attentionBackgroundView.superview!.topAnchor, constant: 287).isActive = true
        attentionBackgroundView.centerXAnchor.constraint(equalTo: attentionBackgroundView.superview!.centerXAnchor).isActive = true
        attentionBackgroundView.widthAnchor.constraint(equalToConstant: CGFloat(271).dp).isActive = true
        attentionBackgroundView.heightAnchor.constraint(equalToConstant: CGFloat(50).dp).isActive = true
        attentionBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        attentionLabel.centerXAnchor.constraint(equalTo: attentionLabel.superview!.centerXAnchor).isActive = true
        attentionLabel.centerYAnchor.constraint(equalTo: attentionLabel.superview!.centerYAnchor).isActive = true
        attentionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        causeLabel.topAnchor.constraint(equalTo: attentionBackgroundView.bottomAnchor, constant: 21).isActive = true
        causeLabel.leftAnchor.constraint(equalTo: attentionBackgroundView.leftAnchor).isActive = true
        causeLabel.rightAnchor.constraint(equalTo: attentionBackgroundView.rightAnchor).isActive = true
        causeLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
