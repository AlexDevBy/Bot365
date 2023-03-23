//
//  CalendarView.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import SnapKit

class RemindersListView: UIView {
    
    
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
        addSubview(tableView)
        addSubview(informationView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(64)
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(16)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        informationView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(24)
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(16)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-16)
            make.height.equalTo(75)
        }
    }
}
