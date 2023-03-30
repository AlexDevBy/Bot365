//
//  LocationView.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import FSCalendar
import SnapKit

class CreateReminderView: UIView {
    
    enum Constants {
        static let interItemSpacing: CGFloat = 15
    }
    private var isConfigure = false
    
    let sportObjImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "stadium")
        return img
    }()
    
    let locationImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "reminderLocation")
        return img
    }()
    
    let clockImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "clock")
        return img
    }()
    
    let sportObjectNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.textColor = .black
        lbl.setFont(fontName: .GilroyMedium, sizeXS: 16)
        return lbl
    }()
    
    let addressNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .GilroyMedium, sizeXS: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .black
        return lbl
    }()
    
    let hourLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .GilroyMedium, sizeXS: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.text = "Please, choose date & time"
        lbl.textColor = .black
        return lbl
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    
    let sheduleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Schedule", for: .normal)
        btn.setTitleColor(UIColor(netHex: 0xF4DA4A), for: .normal)
        btn.titleLabel?.setFont(fontName: .GilroyMedium, sizeXS: 16)
        btn.backgroundColor = .AppCollors.backgroundGreen
        btn.layer.cornerRadius = 16
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.background.backgroundColor = UIColor.AppCollors.backgroundGreen
            config.background.cornerRadius = 16
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(font: .GilroyMedium, size: 16)
                return outgoing
            }
            btn.configuration = config
        }
        btn.addTarget(nil, action: #selector(CreateReminderViewController.bottomButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    let chooseDateButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Choose date", for: .normal)
        btn.setTitleColor(.AppCollors.yeallow, for: .normal)
        btn.titleLabel?.setFont(fontName: .GilroyMedium, sizeXS: 16)
        btn.backgroundColor = .AppCollors.backgroundGreen
        btn.layer.cornerRadius = 16
        btn.setImage(UIImage(named: "CalendarIcon"), for: .normal)
        btn.alpha = 0
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.background.backgroundColor = UIColor.AppCollors.backgroundGreen
            config.background.cornerRadius = 16
            config.imagePadding = 40
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(font: .GilroyMedium, size: 16)
                return outgoing
            }
            btn.configuration = config
        } else {
            btn.imageEdgeInsets.right = 40
        }
        btn.addTarget(nil, action: #selector(CreateReminderViewController.dateButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    let chooseTimeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Choose time", for: .normal)
        btn.setTitleColor(.AppCollors.yeallow, for: .normal)
        btn.titleLabel?.setFont(fontName: .GilroyMedium, sizeXS: 16)
        btn.backgroundColor = .AppCollors.backgroundGreen
        btn.layer.cornerRadius = 16
        btn.alpha = 0
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 40
            config.background.backgroundColor = UIColor.AppCollors.backgroundGreen
            config.background.cornerRadius = 16
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(font: .GilroyMedium, size: 16)
                return outgoing
            }
            btn.configuration = config
        }
        btn.addTarget(nil, action: #selector(CreateReminderViewController.timeButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    
    private let informationView: InformationView = {
        let view = InformationView()
        view.alpha = 0
        return view
    }()
    
    let reservedView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "reserved")
        view.alpha = 0
        return view
    }()
    
    let reservedqView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "reservedq")
        view.alpha = 0
        return view
    }()
    
    lazy var calendarView: FSCalendar = {
        let fc = FSCalendar()
        fc.locale = Locale(identifier: "en")
        fc.backgroundColor = .clear
        fc.appearance.caseOptions = [.weekdayUsesUpperCase, .headerUsesCapitalized]
        fc.today = nil
        fc.appearance.headerTitleColor = UIColor(netHex: 0x456BB6)
        fc.firstWeekday = 2
        fc.alpha = 0
        fc.appearance.weekdayFont = UIFont(font: .MontsBold, size: 14)
        fc.dropShadow()
        return fc
    }()
    
    let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.backgroundColor = UIColor.white
        picker.addTarget(nil, action: #selector(CreateReminderViewController.startTimeDiveChanged), for: .valueChanged)
        picker.alpha = 0
        picker.tintColor = .lightGray
        picker.setValue(UIColor.black, forKeyPath: "textColor")
        return picker
    }()
    
    var sportLongImage: UIImage?
    
    private var calendarHeightConstraint = NSLayoutConstraint()
    private var chooseTimeTopConstraint = NSLayoutConstraint()
    private var timePickerHeightConstraint = NSLayoutConstraint()
    private var isCalendarSetup = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !isConfigure else { return }
        isConfigure.toggle()
    }
    
    
    func changeView(for state: LocationScreenViewState) {
        switch state {
        case .initial:
            sportObjectNameLabel.alpha = 1
            informationView.alpha = 0
            self.reservedView.alpha = 0
            self.reservedqView.alpha = 0
            sheduleButton.setTitle("Schedule", for: .normal)
        case .shedule:
            if !isCalendarSetup {
                addSubview(calendarView)
                sheduleStateConstraints()
                calendarViewConstraints()
                timePickerConstraints()
                isCalendarSetup.toggle()
            }
            UIView.animate(withDuration: 0.2,
                           animations: {
                self.sheduleButton.alpha = 0
            }) { _ in
                self.sheduleButton.setTitle("Confirm", for: .normal)
                UIView.animate(withDuration: 0.2) {
                    self.chooseDateButton.alpha = 1
                    self.chooseTimeButton.alpha = 1
                    self.sheduleButton.alpha = 0.5
                }
            }
        case .sheduleSaved:
            informationView.setupView(title: "You reserved an arena!",
                                      subtitle: "")
            UIView.animate(withDuration: 0.2,
                           animations: {
                self.chooseTimeButton.alpha = 0
                self.chooseDateButton.alpha = 0
                self.sheduleButton.alpha = 0
                self.timePicker.alpha = 0
            }, completion: { _ in
                self.sheduleButton.setTitle("Manage reservations", for: .normal)
                UIView.animate(withDuration: 0.2) {
                    self.sheduleButton.alpha = 1
                    self.informationView.alpha = 1
                    self.reservedView.alpha = 1
                    self.reservedqView.alpha = 1
                }
            })
        }
    }
    
    func showCalendar(show: Bool) {
        let height: CGFloat = show ? 217 : 17
        let alpha: CGFloat = show ? 1 : 0
        let bottomButtonAlpha: CGFloat = show ? 0 : 1
        
        chooseTimeTopConstraint.constant = height
        UIView.animate(withDuration: 0.2) {
            self.calendarView.alpha = alpha
            self.sheduleButton.alpha = bottomButtonAlpha
            self.layoutIfNeeded()
        }
    }
    
    func showTimePicker(show: Bool) {
        let height: CGFloat = show ? 150 : 0
        let alpha: CGFloat = show ? 1 : 0
        let oppositAlpha: CGFloat = show ? 0 : 1
        timePickerHeightConstraint.constant = height
        UIView.animate(withDuration: 0.2) {
            self.timePicker.alpha = alpha
            self.layoutIfNeeded()
        }
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(sportObjImage)
        addSubview(sportObjectNameLabel)
        addSubview(locationImage)
        addSubview(addressNameLabel)
        addSubview(clockImage)
        addSubview(hourLabel)
        addSubview(lineView)
        
        
        addSubview(sheduleButton)
        addSubview(chooseTimeButton)
        addSubview(chooseDateButton)
        
        sportObjImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(32)
        }
        
        sportObjectNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sportObjImage.snp.centerY)
            make.left.equalTo(sportObjImage.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(24)
        }
        
        locationImage.snp.makeConstraints { make in
            make.top.equalTo(sportObjImage.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(24)
            make.height.width.equalTo(16)
        }
        
        addressNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationImage.snp.centerY)
            make.left.equalTo(locationImage.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)

        }
        
        clockImage.snp.makeConstraints { make in
            make.centerY.equalTo(hourLabel.snp.centerY)
            make.left.equalTo(locationImage.snp.left)
            make.height.width.equalTo(16)
        }
        
        hourLabel.snp.makeConstraints { make in
            make.top.equalTo(addressNameLabel.snp.bottom).offset(24)
            make.left.equalTo(clockImage.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(hourLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(1)
        }
        
        sheduleButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        setupSavedState()
    }
    
    private func sheduleStateConstraints() {
        
        chooseDateButton.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(271)
        }
        
        chooseTimeTopConstraint = chooseTimeButton.topAnchor.constraint(equalTo: chooseDateButton.bottomAnchor, constant: CGFloat(17).dp)
        chooseTimeTopConstraint.isActive = true
        
        chooseTimeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(271)
        }
        
    }
    
    private func calendarViewConstraints() {
        
        calendarView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(chooseDateButton.snp.bottom).offset(5)
        }
        
        calendarHeightConstraint = calendarView.heightAnchor.constraint(equalToConstant: 200)
        calendarHeightConstraint.isActive = true
        calendarView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func timePickerConstraints() {
        
        timePicker.snp.makeConstraints { make in
            make.top.equalTo(chooseTimeButton.snp.bottom).offset(5)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        timePickerHeightConstraint = timePicker.heightAnchor.constraint(equalToConstant: 150)
        timePickerHeightConstraint.isActive = true
        timePicker.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSavedState() {
        addSubview(informationView)
        addSubview(timePicker)
        addSubview(reservedView)
        addSubview(reservedqView)
        
        
        let height = UIScreen.current.rawValue > 2 ? CGFloat(140).dp : CGFloat(115).dp
        
        reservedView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(124)
        }
        
        reservedqView.snp.makeConstraints { make in
            make.centerX.equalTo(reservedView.snp.centerX)
            make.centerY.equalTo(reservedView.snp.centerY)
            make.height.width.equalTo(40)
        }
        
        informationView.snp.makeConstraints { make in
            make.top.equalTo(reservedView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(75)
        }
    }
    
}
