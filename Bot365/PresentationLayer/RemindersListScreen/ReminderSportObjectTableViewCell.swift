//
//  SportObjectTableViewCell.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import SnapKit

protocol ReminderObjectTableViewCellDelegate: AnyObject {
    func deleteEventTappped(with id: String)
}

class ReminderSportObjectTableViewCell: UITableViewCell, ReusableView {
    
    private enum Constants {
        static let deleteButtonSize: CGFloat = CGFloat(30).dp
    }
    
    private let contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(netHex: 0x091F07)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let arenaImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arenaImage")
        return view
    }()
    
    private let locationImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "calendarImage")
        return view
    }()
    
    private let dateImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "locationImage")
        return view
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .MontsRegular, sizeXS: 16)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .MontsRegular, sizeXS: 16)
        lbl.textColor = .white
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "12.11.1998, 13:30"
        lbl.textColor = .white
        lbl.setFont(fontName: .MontsBold, sizeXS: 16)
        return lbl
    }()
    
    private let routeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .clear
        btn.setImage(UIImage(named: "routeIcon"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(routeEvent), for: .touchUpInside)
        return btn
    }()
    
    
    private let deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor(netHex: 0x214929)
        btn.setTitle("Cancel", for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.tintColor = .white
        btn.titleLabel?.textColor = .white
        btn.addTarget(self, action: #selector(deleteSportEvent), for: .touchUpInside)
        btn.layer.cornerRadius = 16
        return btn
    }()
    
    var event: SportEvent? {
        didSet {
            guard let model = event else { return }
            let format = "HH:mm, EEEE, d MMM , yyyy"
            dateLabel.text = model.date.toString(format)
            titleLabel.text = model.sportObject.address
            subtitleLabel.text = model.sportObject.name
            
            
        }
    }
    
    weak var delegate: ReminderObjectTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func routeEvent() {
        guard let event = event else { return }
        delegate?.deleteEventTappped(with: event.identifier)
    }
    
    @objc
    func deleteSportEvent() {
        guard let event = event else { return }
        delegate?.deleteEventTappped(with: event.identifier)
    }
    
    private func setupView() {
        backgroundColor = .clear

        contentView.addSubview(contentBackgroundView)
        
  
        contentBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(236)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            
        }
        
 
        contentBackgroundView.addSubview(arenaImageView)
        contentBackgroundView.addSubview(locationImageView)
        contentBackgroundView.addSubview(dateImageView)
        
        arenaImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(33.6)
            make.left.equalToSuperview().offset(25.6)
            make.width.height.equalTo(12.8)
        }
        
        locationImageView.snp.makeConstraints { make in
            make.top.equalTo(arenaImageView.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(24)
            make.width.height.equalTo(16)
        }
        
        dateImageView.snp.makeConstraints { make in
            make.top.equalTo(locationImageView.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(24)
            make.width.height.equalTo(16)
        }
       
        
        contentBackgroundView.addSubview(titleLabel)
        contentBackgroundView.addSubview(subtitleLabel)
        contentBackgroundView.addSubview(dateLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(arenaImageView.snp.centerY)
            make.left.equalTo(arenaImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-32)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationImageView.snp.centerY)
            make.left.equalTo(locationImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateImageView.snp.centerY)
            make.left.equalTo(dateImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        
        
        contentBackgroundView.addSubview(deleteButton)
        contentBackgroundView.addSubview(routeButton)
        
        deleteButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
        
        routeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalToSuperview().offset(-16)
            make.height.width.equalTo(16)
        }
    }
}
