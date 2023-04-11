//
//  SportObjectTableViewCell.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import SnapKit

//protocol SportsObjectTableViewCellDelegate: AnyObject {
//    func reserveEventTappped(with id: String)
//}


class SportObjectTableViewCell: UITableViewCell, ReusableView {
    
    var reservedTappedAction: (()->Void)?

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .GeneralSansMedium, sizeXS: 16)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .SFProRegular, sizeXS: 12)
        lbl.textColor = .white
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let contentBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let sportObjectImageView: UIImageView = {
        let iv = UIImageView()
        iv.setContentHuggingPriority(.required, for: .horizontal)
        return iv
    }()
    
    private let mapView: UIView = {
        let btn = UIView()
        btn.layer.cornerRadius = 16
        return btn
    }()
    
    private let mapButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 16
        btn.setImage(UIImage(named: "toMap"), for: .normal)
        return btn
    }()
    
    private lazy var reserveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 12
        btn.setTitle("Reserve", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.systemGray, for: .selected)
        btn.titleLabel?.textColor = .white
        btn.tag = 0
        btn.addTarget(self, action: #selector(reserve), for: .touchUpInside)
        return btn
    }()
    
    var shouldCornerEdges = false
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if reserveButton.point(inside: reserveButton.convert(point, from: self.coordinateSpace), with: event) {
            print("lol")
            return self
        }
        print("wtf")
        return nil
    }
    
    @objc
    func reserve() {
        reservedTappedAction
    }
//
    var object: SportObject? {
        didSet {
            guard let model = object else { return }
            titleLabel.text = model.name
            subtitleLabel.text = model.address
            reserveButton.backgroundColor = model.type.backgroundColor2
            mapView.backgroundColor = model.type.backgroundColor2
            sportObjectImageView.image = UIImage(named: model.type.sportObjectListImage)
            contentBackgroundView.backgroundColor = model.type.backgroundColor
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shouldCornerEdges = false
    }

    private func setupView() {
        contentView.addSubview(contentBackgroundView)
        contentBackgroundView.addSubview(sportObjectImageView)
        contentBackgroundView.addSubview(titleLabel)
        contentBackgroundView.addSubview(subtitleLabel)
        contentBackgroundView.addSubview(mapView)
        mapView.addSubview(mapButton)
        contentBackgroundView.addSubview(reserveButton)
        
        contentBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(72)
        }
        
        sportObjectImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(40)
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(sportObjectImageView.snp.top)
            make.left.equalTo(sportObjectImageView.snp.right).offset(8)
            make.height.equalTo(24)
            make.width.equalTo(134)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(sportObjectImageView.snp.right).offset(8)
            make.height.equalTo(16)
            make.width.equalTo(134)
        }
        
        reserveButton.snp.makeConstraints { make in
            make.top.equalTo(contentBackgroundView.snp.top).offset(20)
            make.bottom.equalTo(contentBackgroundView.snp.bottom).offset(-20)
            make.right.equalTo(contentBackgroundView.snp.right).offset(-8)
            make.height.equalTo(32)
            make.width.equalTo(86)
        }

        mapView.snp.makeConstraints { make in
            make.top.equalTo(contentBackgroundView.snp.top).offset(20)
            make.bottom.equalTo(contentBackgroundView.snp.bottom).offset(-20)
            make.right.equalTo(reserveButton.snp.left).offset(-12)
            make.height.equalTo(32)
            make.width.equalTo(32)
        }
        
        mapButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.top).offset(8)
            make.bottom.equalTo(mapView.snp.bottom).offset(-8)
            make.right.equalTo(mapView.snp.right).offset(-8)
            make.left.equalTo(mapView.snp.left).offset(8)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shouldCornerEdges {
            self.roundCorners([.topLeft, .topRight], radius: 16.0)
        } else {
            self.roundCorners([.allCorners], radius: 0.0)
        }
    }
    
    func configure(type: SportType, indexPath: IndexPath) {
        backgroundColor = type.backgroundColor2
        shouldCornerEdges = indexPath.row == 0
    }
}


final class TransparentTableViewCell: UITableViewCell, ReusableView {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        heightAnchor.constraint(equalToConstant: 214.0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
    }

}
