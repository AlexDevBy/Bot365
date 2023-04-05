//
//  CalendarView.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import SnapKit

class RemindersListView: UIView {
    
    

    
    
    
    let reservationsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Your reservations"
        lbl.setFont(fontName: .GeneralSansMedium, sizeXS: 16)
        return lbl
    }()
    
    let circleView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "reminderElipse")
        return view
    }()
    
    let circleImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "reminderCalendar")
        return view
    }()
    
    let noResLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.text = "No reservations"
        lbl.setFont(fontName: .GeneralSansMedium, sizeXS: 24)
        lbl.alpha = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    let noResLabel2: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(netHex: 0x858585)
        lbl.text = "You don’t have reservations yet"
        lbl.setFont(fontName: .GeneralSansMedium, sizeXS: 16)
        lbl.alpha = 0
        return lbl
    }()
    
    
    let tableView: UITableView = {
        let tbl = UITableView()
        tbl.showsVerticalScrollIndicator = false
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.rowHeight = 250.0
        tbl.separatorStyle = .none
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
        let alpha2: CGFloat = show ? 0 : 1
        UIView.animate(withDuration: 0.2) {
            self.noResLabel.alpha = alpha
            self.noResLabel2.alpha = alpha
            self.circleView.alpha = alpha
            self.circleImageView.alpha = alpha
            self.reservationsLabel.alpha = alpha2
        }
    }
    
    private func setupView() {
        backgroundColor = .white
        
        addSubview(reservationsLabel)
        addSubview(tableView)
        addSubview(circleView)
        circleView.addSubview(circleImageView)
        addSubview(noResLabel)
        addSubview(noResLabel2)
        
        
        reservationsLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(24)
            make.left.equalToSuperview().offset(16)
            
        }
     
        circleView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(154)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(124)
        }
        
        circleImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.left.equalToSuperview().offset(36)
            make.right.equalToSuperview().offset(-36)
            make.bottom.equalToSuperview().offset(-36)
        }
        
        noResLabel.snp.makeConstraints { make in
            make.top.equalTo(circleView.snp.bottom).offset(16)
            make.centerX.equalTo(circleView.snp.centerX)
            make.height.equalTo(32)
        }
        
        noResLabel2.snp.makeConstraints { make in
            make.top.equalTo(noResLabel.snp.bottom).offset(8)
            make.centerX.equalTo(noResLabel.snp.centerX)
            make.height.equalTo(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(64)
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(16)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
