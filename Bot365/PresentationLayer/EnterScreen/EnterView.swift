//
//  EnterView.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import SnapKit

class EnterView: UIView {

    private enum Constants {
        static let appleSignIn: String = "Sign in with Apple"
        static let termsAndConditions: String = "Agree on \(Constants.terms)"
        static let cornerRadius: CGFloat = 16
        static let allowCornerRaidus: CGFloat = 20
        static let terms: String = "Terms & Conditions"
        static let privacy: String = "Privacy Policy"
        static let yeallowCornerRaidus: CGFloat = 15
        static let circleSize: CGFloat = UIScreen.current.rawValue > 2 ? CGFloat(127).dp : CGFloat(107).dp
    }
    
    var signInHandler: (() -> Void)?
    
    let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.progress = 0.66
        view.progressTintColor = .AppCollors.backgroundGreen
        view.sizeToFit()
        return view
    }()
    
    let ellipseView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Ellipse")
        return view
    }()
    
    let pushIconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "loginIcon")
        return view
    }()
    
    let causeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.text = "Sign up"
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.setFont(fontName: .GilroyMedium, sizeXS: 24)
        return lbl
    }()
    
    let secondCauseLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .systemGray
        lbl.text = "Easily connect with one tap via your Apple account for quick, secure access to our app."
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.setFont(fontName: .GilroyMedium, sizeXS: 16)
        return lbl
    }()

    
    private let signInButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        btn.setTitle(Constants.appleSignIn, for: .normal)
        btn.tintColor = .AppCollors.backgroundGreen
        btn.titleLabel!.setFont(fontName: .GilroyMedium, sizeXS: 16)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 10
            config.background.backgroundColor = .AppCollors.backgroundGreen
            config.background.cornerRadius = 16
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(font: .GilroyMedium, size: 16)
                return outgoing
            }
            btn.configuration = config
        } else {
            btn.backgroundColor = .AppCollors.backgroundGreen
        }
        btn.layer.cornerRadius = Constants.cornerRadius
        btn.setTitleColor(.yellow, for: .normal)
        return btn
    }()

    let termsAndPolicyTextView: UITextView = {
        let txtV = UITextView()
        let text = Constants.termsAndConditions
        txtV.textColor = .black
        txtV.text = text
        txtV.backgroundColor = .clear
        return txtV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareAttributesForTextView() {
//        let text = (termsAndPolicyTextView.text ?? "Agree on Terms & Conditions") as NSString
        let text = "Agree on Terms Conditions" as NSString
        termsAndPolicyTextView.font = UIFont(font: .GilroyMedium, size: 16)
        let attributedString = termsAndPolicyTextView.addHyperLinksToText(
            originalText: text as String,
            hyperLinks: ["Terms Conditions": "https://bot365.tech/#eula"],
            font:  UIFont(font: .GilroyMedium, size: 16)
        )
        let linkAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.AppCollors.backgroundGreen ,
        ]
        
        termsAndPolicyTextView.linkTextAttributes = linkAttributes
        termsAndPolicyTextView.textAlignment = .left
        termsAndPolicyTextView.isUserInteractionEnabled = true
        termsAndPolicyTextView.isEditable = false
        termsAndPolicyTextView.attributedText = attributedString
        termsAndPolicyTextView.textColor = .black
    }
    
    
    
    @objc
    private func signInTapped() {
        signInHandler?()
    }
    
    private func setupView() {
        backgroundColor = .white
        
        addSubview(progressView)
        addSubview(ellipseView)
        ellipseView.addSubview(pushIconView)
        addSubview(causeLabel)
        addSubview(secondCauseLabel)
        addSubview(termsAndPolicyTextView)
        addSubview(signInButton)
        addConstraints()
        prepareAttributesForTextView()
        
    }
    
    private func addConstraints() {
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(32)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(4)
        }
        
        ellipseView.snp.makeConstraints { make in
            make.centerX.equalTo(signInButton.snp.centerX)
            make.height.equalTo(148)
            make.width.equalTo(148)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(141)
        }
        
        pushIconView.snp.makeConstraints { make in
            make.top.equalTo(ellipseView.snp.top).offset(48)
            make.right.equalTo(ellipseView.snp.right).offset(-48)
            make.left.equalTo(ellipseView.snp.left).offset(48)
            make.bottom.equalTo(ellipseView.snp.bottom).offset(-48)
        }
        
        causeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(signInButton.snp.centerX)
            make.height.equalTo(64)
            make.width.equalTo(192)
            make.top.equalTo(ellipseView.snp.bottom).offset(24)
        }
        
        secondCauseLabel.snp.makeConstraints { make in
            make.centerX.equalTo(signInButton.snp.centerX)
            make.height.equalTo(77)
            make.width.equalTo(258)
            make.top.equalTo(causeLabel.snp.bottom).offset(8)
        }
        
        termsAndPolicyTextView.snp.makeConstraints { make in
            make.centerX.equalTo(signInButton.snp.centerX)
            make.height.equalTo(25)
            make.width.equalTo(220)
            make.bottom.equalTo(signInButton.snp.top).offset(-24)
        }
        
        signInButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).inset(32)
            make.left.equalTo(self.snp.left).offset(32)
            make.right.equalTo(self.snp.right).inset(32)
            make.height.equalTo(48)
        }
    }
}
