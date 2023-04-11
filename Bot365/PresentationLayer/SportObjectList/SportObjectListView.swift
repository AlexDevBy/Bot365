//
//  SportObjectListView.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import NVActivityIndicatorView
import SnapKit

class SportObjectListView: UIView {
    
    enum Constants {
        static let allow: String = "Allow"
        static let cornerRaidus: CGFloat = 15
        static let allowCornerRaidus: CGFloat = 20
    }
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .GeneralSansMedium, sizeXS: 24)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()
    
    let tableView: UITableView = {
        let tbl = UITableView()
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.backgroundColor = .clear
//        tbl.contentInset.bottom = 600
        tbl.layer.cornerRadius = 16
        tbl.separatorStyle = .none
        tbl.rowHeight = UITableView.automaticDimension
        tbl.showsVerticalScrollIndicator = false
        return tbl
    }()
    
    let sectionBackgroundView = UIView()
    
    let errorLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let informationView: InformationView = {
        let view = InformationView()
        view.setupView(title: "We did not have permission to check your location",
                       subtitle: "Please, allow us to track your location to find the most relevant sports facilities.")
        return view
    }()
    
    private let loaderView: NVActivityIndicatorView = {
        let v = NVActivityIndicatorView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: CGFloat(40).dp,
                                                      height: CGFloat(40).dp),
                                        type: NVActivityIndicatorType.circleStrokeSpin)
        v.color = UIColor.AppCollors.darkBlue
        v.layer.zPosition = 100
        return v
    }()
    
    private let messageLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .MontsRegular, sizeXS: 12)
        lbl.textColor = .gray
        lbl.text = "Please wait.\nIf there are a lot of places near you, it may take a while to load."
        lbl.isHidden = true
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let allowButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(Constants.allow.uppercased(), for: .normal)
        btn.setTitleColor(.yellow, for: .normal)
        btn.backgroundColor = .AppCollors.backgroundGreen
        btn.layer.cornerRadius = Constants.allowCornerRaidus
        btn.titleLabel?.setFont(fontName: .SFProRegular, sizeXS: 18)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.background.backgroundColor = .AppCollors.backgroundGreen
            config.background.cornerRadius = Constants.allowCornerRaidus
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(font: .SFProRegular, size: 18)
                return outgoing
            }
            btn.configuration = config
        }
        btn.addTarget(nil, action: #selector(SportObjectListViewController.allowLocationButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    let categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    private var gradientLayer = CAGradientLayer()
    private var isConfigure = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupNoLocationView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !isConfigure else { return }
        isConfigure.toggle()
    }
    
    func setupView(for state: SportObjectListViewState) {
        switch state {
        case .locationExist:
            tableView.isHidden = true
            informationView.isHidden = true
            allowButton.isHidden = true
            errorLabel.text = ""
        case .noLocation:
            tableView.isHidden = true
            informationView.isHidden = false
            allowButton.isHidden = false
            errorLabel.text = ""
            showLoader(toggle: false)
        case .error(let text):
            errorLabel.text = text
            showLoader(toggle: false)
        default:
            break
        }
    }
    
    func showLoader(toggle: Bool) {
        if toggle {
            loaderView.startAnimating()
            messageLabel.isHidden = false
        } else {
            loaderView.stopAnimating()
            messageLabel.isHidden = true
        }
    }
    
    private func setupView() {
//        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(categoryImageView)
        addSubview(sectionBackgroundView)
        addSubview(tableView)
        tableView.addSubview(errorLabel)
        addSubview(loaderView)
        addSubview(messageLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(24)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(32)
        }
        
        categoryImageView.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(-60)
            make.width.equalTo(376)
            make.height.equalTo(308)
        }
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        loaderView.centerYAnchor.constraint(equalTo: loaderView.superview!.centerYAnchor).isActive = true
        loaderView.centerXAnchor.constraint(equalTo: loaderView.superview!.centerXAnchor).isActive = true
        loaderView.widthAnchor.constraint(equalToConstant: CGFloat(35).dp).isActive = true
        loaderView.heightAnchor.constraint(equalToConstant: CGFloat(35).dp).isActive = true
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.topAnchor.constraint(equalTo: loaderView.bottomAnchor, constant: 5).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: messageLabel.superview!.leftAnchor, constant: 40).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: messageLabel.superview!.rightAnchor, constant: -40).isActive = true
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        errorLabel.topAnchor.constraint(equalTo: errorLabel.superview!.topAnchor, constant: 100).isActive = true
        errorLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupNoLocationView() {
        addSubview(informationView)
        addSubview(allowButton)
        
        informationView.topAnchor.constraint(equalTo: categoryImageView.bottomAnchor, constant: -15).isActive = true
        informationView.leftAnchor.constraint(equalTo: informationView.superview!.leftAnchor, constant: 16).isActive = true
        informationView.rightAnchor.constraint(equalTo: informationView.superview!.rightAnchor, constant: -16).isActive = true
        informationView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        informationView.translatesAutoresizingMaskIntoConstraints = false
        
        allowButton.widthAnchor.constraint(equalToConstant: CGFloat(271).dp).isActive = true
        allowButton.heightAnchor.constraint(equalToConstant: CGFloat(60).dp).isActive = true
        allowButton.topAnchor.constraint(equalTo: informationView.bottomAnchor, constant: 25).isActive = true
        allowButton.centerXAnchor.constraint(equalTo: allowButton.superview!.centerXAnchor).isActive = true
        allowButton.translatesAutoresizingMaskIntoConstraints = false
    }
}
