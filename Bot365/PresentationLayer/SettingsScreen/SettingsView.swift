//
//  SettingsView.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 23.11.2022.
//

import UIKit

class Settingsview: UIView {
    
    private let goImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "GoLiveGoSport")
        return iv
    }()
    
    private let profileTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Profile"
        lbl.setFont(fontName: .MontsBold, sizeXS: 24)
        return lbl
    }()
    
    let tableView: UITableView = {
        let tbl = UITableView()
        tbl.showsVerticalScrollIndicator = false
        tbl.rowHeight = UIScreen.current.rawValue > 2 ? CGFloat(62).dp : CGFloat(52).dp
        tbl.separatorStyle = .none
        tbl.contentInset.bottom = 200
        tbl.backgroundColor = .white
        return tbl
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
        addSubview(goImageView)
        addSubview(profileTitleLabel)
        addSubview(tableView)
        
        goImageView.topAnchor.constraint(equalTo: goImageView.superview!.safeTopAnchor, constant: 40).isActive = true
        goImageView.leftAnchor.constraint(equalTo: goImageView.superview!.leftAnchor, constant: 16).isActive = true
        goImageView.translatesAutoresizingMaskIntoConstraints = false
        
        profileTitleLabel.topAnchor.constraint(equalTo: goImageView.bottomAnchor, constant: 13).isActive = true
        profileTitleLabel.leftAnchor.constraint(equalTo: profileTitleLabel.superview!.leftAnchor, constant: 16).isActive = true
        profileTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: profileTitleLabel.bottomAnchor, constant: 13).isActive = true
        tableView.leftAnchor.constraint(equalTo: tableView.superview!.leftAnchor, constant: 16).isActive = true
        tableView.rightAnchor.constraint(equalTo: tableView.superview!.rightAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: tableView.superview!.bottomAnchor, constant: 150).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
}
