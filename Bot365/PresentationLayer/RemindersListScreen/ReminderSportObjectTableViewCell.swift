//
//  SportObjectTableViewCell.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 23.11.2022.
//

import UIKit

protocol SportsObjectTableViewCellDelegate: AnyObject {
    func deleteEventTappped(with id: String)
}

class ReminderSportObjectTableViewCell: UITableViewCell, ReusableView {
    
    private enum Constants {
        static let deleteButtonSize: CGFloat = CGFloat(30).dp
    }
    
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "18.12.2022, 08:30"
        lbl.textColor = .black
        lbl.setFont(fontName: .MontsBold, sizeXS: 14)
        return lbl
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .MontsBold, sizeXS: 14)
        lbl.textColor = .white
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .MontsRegular, sizeXS: 10)
        lbl.textColor = .white
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 3
        return lbl
    }()
    
    private let contentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(netHex: 0x5B689B)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let stadiumImageView: UIImageView = {
        let iv = UIImageView()
        iv.setContentHuggingPriority(.required, for: .horizontal)
        return iv
    }()
    
    private let deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .white
        btn.setImage(UIImage(named: "Delete2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.layer.cornerRadius = Constants.deleteButtonSize/2
        return btn
    }()
    
    var event: SportEvent? {
        didSet {
            guard let model = event else { return }
            let format = "dd.MM.yyyy, HH:mm"
            dateLabel.text = model.date.toString(format)
            titleLabel.text = model.sportObject.name
            subtitleLabel.text = model.sportObject.address
            stadiumImageView.image = UIImage(named: model.sportObject.type.sportObjectListImage)
            
            deleteButton.addTarget(self, action: #selector(deleteSportEvent), for: .touchUpInside)
        }
    }
    
    weak var delegate: SportsObjectTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func deleteSportEvent() {
        guard let event = event else { return }
        delegate?.deleteEventTappped(with: event.identifier)
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentBackgroundView)
        contentBackgroundView.addSubview(stadiumImageView)
        contentBackgroundView.addSubview(deleteButton)
        contentBackgroundView.addSubview(titleLabel)
        contentBackgroundView.addSubview(subtitleLabel)
        
        dateLabel.leftAnchor.constraint(equalTo: dateLabel.superview!.leftAnchor, constant: 0).isActive = true
        dateLabel.topAnchor.constraint(equalTo: dateLabel.superview!.topAnchor, constant: 13).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: dateLabel.superview!.rightAnchor).isActive = true
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentBackgroundView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 13).isActive = true
        contentBackgroundView.heightAnchor.constraint(equalToConstant: CGFloat(100).dp).isActive = true
        contentBackgroundView.leftAnchor.constraint(equalTo: contentBackgroundView.superview!.leftAnchor).isActive = true
        contentBackgroundView.rightAnchor.constraint(equalTo: contentBackgroundView.superview!.rightAnchor).isActive = true
        contentBackgroundView.bottomAnchor.constraint(equalTo: contentBackgroundView.superview!.bottomAnchor, constant: 0).isActive = true
        contentBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: titleLabel.superview!.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: titleLabel.superview!.leftAnchor, constant: 21).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: stadiumImageView.leftAnchor, constant: -25).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: stadiumImageView.leftAnchor, constant: -25).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.superview!.bottomAnchor, constant: -16).isActive = true
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stadiumImageView.centerYAnchor.constraint(equalTo: stadiumImageView.superview!.centerYAnchor).isActive = true
        stadiumImageView.rightAnchor.constraint(equalTo: stadiumImageView.superview!.rightAnchor).isActive = true
        stadiumImageView.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.topAnchor.constraint(equalTo: deleteButton.superview!.topAnchor, constant: 6).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: deleteButton.superview!.rightAnchor, constant: -7).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: Constants.deleteButtonSize).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: Constants.deleteButtonSize).isActive = true
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
    }
}
