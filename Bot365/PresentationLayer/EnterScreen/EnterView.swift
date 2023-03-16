//
//  EnterView.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 22.11.2022.
//

import UIKit

class EnterView: UIView {
    
    private enum Constants {
        static let title: String = "nacional"
        static let subtitle: String = "Find sports near you"
        static let appleSignIn: String = "Sign In with Apple"
        static let termsAndConditions: String = "Please, read our\n\(Constants.terms) and \(Constants.privacy)"
        static let cornerRadius: CGFloat = 20
        static let terms: String = "Terms and Conditions"
        static let privacy: String = "Privacy Policy"
        static let yeallowCornerRaidus: CGFloat = 15
        static let circleSize: CGFloat = UIScreen.current.rawValue > 2 ? CGFloat(127).dp : CGFloat(107).dp
    }
    
    private let cicrleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.circleSize/2
        return view
    }()
    
    private let appNameTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = Constants.title
        lbl.textColor = .white
        let size: CGFloat = UIScreen.current.rawValue > 2 ? 67 : 57
        lbl.setFont(fontName: .MuseoModernoBold, sizeXS: size)
        return lbl
    }()
    
    private let subtitleBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .AppCollors.yeallow
        view.layer.cornerRadius = Constants.yeallowCornerRaidus
        view.transform = view.transform.rotated(by: -.pi/18)
        return view
    }()
    
    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = Constants.subtitle.uppercased()
        lbl.textColor = UIColor.AppCollors.darkBlue
        let size: CGFloat = UIScreen.current.rawValue > 2 ? 18 : 16
        lbl.setFont(fontName: .MontsBlack, sizeXS: size)
        return lbl
    }()
    
    private let termsAndPolicyLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    private let signInButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(Constants.appleSignIn, for: .normal)
        btn.setImage(UIImage(named: "AppleIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.tintColor = .white
        btn.titleLabel!.setFont(fontName: .MontsBold, sizeXS: 18)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 10
            config.background.backgroundColor = UIColor.white
            config.background.cornerRadius = 25
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(font: .MontsBold, size: 18)
                return outgoing
            }
            btn.configuration = config
        } else {
            btn.imageEdgeInsets.right = 5
            btn.backgroundColor = .white
        }
        btn.layer.cornerRadius = Constants.cornerRadius
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    var signInHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let termsAndPolicyTextView: UITextView = {
        let txtV = UITextView()
        let text = Constants.termsAndConditions
        txtV.textColor = .white
        txtV.text = text
        txtV.backgroundColor = .clear
        return txtV
    }()
    
    func prepareAttributesForTextView() {
        let text = (termsAndPolicyTextView.text ?? "") as NSString
        termsAndPolicyTextView.font = UIFont(font: .GilroyMedium, size: 12)
        let attributedString = termsAndPolicyTextView.addHyperLinksToText(
            originalText: text as String, hyperLinks: [
                Constants.privacy: "https://get-nacional.space/privacy.html",
                Constants.terms: "https://get-nacional.space/terms.html"
            ],
            font:  UIFont(font: .GilroyMedium, size: 12)
        )
        let linkAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        termsAndPolicyTextView.linkTextAttributes = linkAttributes
        termsAndPolicyTextView.textColor = .white
        termsAndPolicyTextView.textAlignment = .center
        termsAndPolicyTextView.isUserInteractionEnabled = true
        termsAndPolicyTextView.isEditable = false
        termsAndPolicyTextView.attributedText = attributedString
    }
    
    private func setupView() {
        backgroundColor = UIColor.AppCollors.backgroundBlue
        addSubview(cicrleView)
        addSubview(appNameTitleLabel)
        addSubview(subtitleBackgroundView)
        subtitleBackgroundView.addSubview(subtitleLabel)
        addSubview(termsAndPolicyTextView)
        addSubview(signInButton)
        addConstraints()
        prepareAttributesForTextView()
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
    }
    
    @objc
    private func signInTapped() {
        signInHandler?()
    }
    
    private func addConstraints() {
        // Cicle
        cicrleView.widthAnchor.constraint(equalToConstant: Constants.circleSize).isActive = true
        cicrleView.heightAnchor.constraint(equalToConstant: Constants.circleSize).isActive = true
        let topAnchor: CGFloat = UIScreen.current.rawValue > 2 ? CGFloat(199).dp : CGFloat(159).dp
        cicrleView.topAnchor.constraint(equalTo: cicrleView.superview!.topAnchor, constant: topAnchor).isActive = true
        cicrleView.leftAnchor.constraint(equalTo: cicrleView.superview!.leftAnchor, constant: 52).isActive = true
        cicrleView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title
        appNameTitleLabel.topAnchor.constraint(equalTo: cicrleView.bottomAnchor, constant: -15).isActive = true
        appNameTitleLabel.leftAnchor.constraint(equalTo: cicrleView.leftAnchor, constant: 0).isActive = true
        appNameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Subtitle background
        subtitleBackgroundView.centerXAnchor.constraint(equalTo: appNameTitleLabel.centerXAnchor).isActive = true
        subtitleBackgroundView.topAnchor.constraint(equalTo: appNameTitleLabel.bottomAnchor, constant: -13).isActive = true
        subtitleBackgroundView.leftAnchor.constraint(equalTo: subtitleLabel.leftAnchor, constant: -13).isActive = true
        subtitleBackgroundView.rightAnchor.constraint(equalTo: subtitleLabel.rightAnchor, constant: 13).isActive = true
        subtitleBackgroundView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        subtitleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // Subtitle
        subtitleLabel.centerYAnchor.constraint(equalTo: subtitleLabel.superview!.centerYAnchor).isActive = true
        subtitleLabel.centerXAnchor.constraint(equalTo: subtitleLabel.superview!.centerXAnchor).isActive = true
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Terms
        termsAndPolicyTextView.leftAnchor.constraint(equalTo: termsAndPolicyTextView.superview!.leftAnchor, constant: 52).isActive = true
        termsAndPolicyTextView.rightAnchor.constraint(equalTo: termsAndPolicyTextView.superview!.rightAnchor, constant: -52).isActive = true
        termsAndPolicyTextView.bottomAnchor.constraint(equalTo: termsAndPolicyTextView.superview!.bottomAnchor, constant: -61).isActive = true
        termsAndPolicyTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        termsAndPolicyTextView.translatesAutoresizingMaskIntoConstraints = false
        
        // Sign in
        signInButton.leftAnchor.constraint(equalTo: signInButton.superview!.leftAnchor, constant: CGFloat(52).dp).isActive = true
        signInButton.rightAnchor.constraint(equalTo: signInButton.superview!.rightAnchor, constant: -CGFloat(52).dp).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: CGFloat(60).dp).isActive = true
        signInButton.bottomAnchor.constraint(equalTo: termsAndPolicyTextView.topAnchor, constant: -CGFloat(75).dp).isActive = true
        signInButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
