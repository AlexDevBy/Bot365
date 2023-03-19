//
//  CalendarView.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit

class RemindersListView: UIView {
    
    private let goImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "GoLiveGoSport")
        return iv
    }()
    
    private let informationView: InformationView = {
        let view = InformationView()
        view.setupView(title: "You don’t have reminders yet", subtitle: "Please, add them first")
        view.alpha = 0
        return view
    }()
    
    let tableView: UITableView = {
        let tbl = UITableView()
        tbl.showsVerticalScrollIndicator = false
        tbl.contentInset.bottom = 100
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
    
    func showHideEmptyReminders(show: Bool) {
        let alpha: CGFloat = show ? 1 : 0
        UIView.animate(withDuration: 0.2) {
            self.informationView.alpha = alpha
        }
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(goImageView)
        addSubview(tableView)
        addSubview(informationView)
        
        goImageView.topAnchor.constraint(equalTo: goImageView.superview!.safeTopAnchor, constant: 40).isActive = true
        goImageView.leftAnchor.constraint(equalTo: goImageView.superview!.leftAnchor, constant: 16).isActive = true
        goImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // TableView
        tableView.topAnchor.constraint(equalTo: goImageView.bottomAnchor, constant: 13).isActive = true
        tableView.leftAnchor.constraint(equalTo: tableView.superview!.leftAnchor, constant: 16).isActive = true
        tableView.rightAnchor.constraint(equalTo: tableView.superview!.rightAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: tableView.superview!.bottomAnchor, constant: 0).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        informationView.topAnchor.constraint(equalTo: goImageView.bottomAnchor, constant: 24).isActive = true
        informationView.leftAnchor.constraint(equalTo: informationView.superview!.leftAnchor, constant: 13).isActive = true
        informationView.rightAnchor.constraint(equalTo: informationView.superview!.rightAnchor, constant: -13).isActive = true
        informationView.heightAnchor.constraint(equalToConstant: CGFloat(75)).isActive = true
        informationView.translatesAutoresizingMaskIntoConstraints = false
    }
}
