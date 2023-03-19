//
//  LocationView.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import FSCalendar

class CreateReminderView: UIView {
    
    enum Constants {
        static let interItemSpacing: CGFloat = 15
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.alpha = 0
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private var gradientLayer = CAGradientLayer()
    private var isConfigure = false
    
    let sportObjectNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = .black
        let size: CGFloat = UIScreen.current.rawValue > 2 ? 24: 17
        lbl.setFont(fontName: .MontsBlack, sizeXS: size)
        return lbl
    }()
    
    let addressNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .MontsBold, sizeXS: 14)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.textColor = .black
        return lbl
    }()
    
    private let availableTitlleLabel: UILabel = {
        let lbl = UILabel()
        let size: CGFloat = UIScreen.current.rawValue > 2 ? 14 : 12
        lbl.setFont(fontName: .MontsBold, sizeXS: size)
        lbl.text = "Available for"
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
    }()
    
    let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.interItemSpacing
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let sheduleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Schedule".uppercased(), for: .normal)
        btn.setTitleColor(.AppCollors.darkBlue, for: .normal)
        btn.titleLabel?.setFont(fontName: .MontsBlack, sizeXS: 18)
        btn.backgroundColor = .AppCollors.yeallow
        btn.layer.cornerRadius = 15
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.background.backgroundColor = UIColor.AppCollors.yeallow
            config.background.cornerRadius = 15
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(font: .MontsBlack, size: 18)
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
        btn.setTitleColor(.AppCollors.darkBlue, for: .normal)
        btn.titleLabel?.setFont(fontName: .MontsBold, sizeXS: 14)
        btn.backgroundColor = .AppCollors.yeallow
        btn.layer.cornerRadius = 15
        btn.setImage(UIImage(named: "CalendarIcon"), for: .normal)
        btn.alpha = 0
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.background.backgroundColor = UIColor.AppCollors.yeallow
            config.background.cornerRadius = 15
            config.imagePadding = 40
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(font: .MontsBold, size: 14)
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
        btn.setTitleColor(.AppCollors.darkBlue, for: .normal)
        btn.titleLabel?.setFont(fontName: .MontsBold, sizeXS: 14)
        btn.backgroundColor = .AppCollors.yeallow
        btn.layer.cornerRadius = 15
        btn.setImage(UIImage(named: "AlarmIcon"), for: .normal)
        btn.alpha = 0
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 40
            config.background.backgroundColor = UIColor.AppCollors.yeallow
            config.background.cornerRadius = 15
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(font: .MontsBold, size: 14)
                return outgoing
            }
            btn.configuration = config
        } else {
            btn.imageEdgeInsets.right = 40
        }
        btn.addTarget(nil, action: #selector(CreateReminderViewController.timeButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private let pleaseLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Please make sure the facility has a booking available for this time"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.setFont(fontName: .GilroyMedium, sizeXS: 14)
        lbl.alpha = 0
        return lbl
    }()
    
    private let goImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "GoLiveGoSport")
        return iv
    }()
    
    private let categoriesImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "FootbolSuggestions")
        iv.alpha = 0
        return iv
    }()
    
    private let informationView: InformationView = {
        let view = InformationView()
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
    
    private var addressLabelBottomSheduleStateConstaint = NSLayoutConstraint()
    private var addressLabelTopSavedStateConstaint = NSLayoutConstraint()
    private var bottomButtonTopConstraint = NSLayoutConstraint()
    private var bottomButtonBottomConstraint = NSLayoutConstraint()
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
        setGradientBackground()
        isConfigure.toggle()
    }
    
    func setGradientBackground() {
        let colorTop: CGColor = UIColor.white.withAlphaComponent(0).cgColor
        let colorBottom: CGColor = UIColor.white.cgColor
        let newLayer = CAGradientLayer()
        newLayer.colors = [colorTop, colorBottom]
        newLayer.locations = [0.5, 1.0]
        newLayer.frame = imageView.frame
        gradientLayer = newLayer
        imageView.layer.addSublayer(gradientLayer)
    }
    
    func changeView(for state: LocationScreenViewState) {
        switch state {
        case .initial:
            bottomButtonTopConstraint.isActive = false
            bottomButtonBottomConstraint.isActive = true
            addressLabelTopSavedStateConstaint.isActive = false
            addressLabelBottomSheduleStateConstaint.isActive = true
            categoriesCollectionView.alpha = 1
            availableTitlleLabel.alpha = 1
            sportObjectNameLabel.alpha = 1
            imageView.alpha = 1
            pleaseLabel.alpha = 0
            informationView.alpha = 0
            categoriesImageView.alpha = 0
            goImageView.alpha = 0
            sheduleButton.setTitle("Schedule".uppercased(), for: .normal)
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
                self.categoriesCollectionView.alpha = 0
                self.availableTitlleLabel.alpha = 0
                self.sheduleButton.alpha = 0
            }) { _ in
                self.sheduleButton.setTitle("SAVE", for: .normal)
                UIView.animate(withDuration: 0.2) {
                    self.pleaseLabel.alpha = 1
                    self.chooseDateButton.alpha = 1
                    self.chooseTimeButton.alpha = 1
                    self.sheduleButton.alpha = 0.5
                }
            }
        case .sheduleSaved:
            informationView.setupView(title: "Time is saved",
                                      subtitle: "We also add reminder for this time to you")
            UIView.animate(withDuration: 0.2,
                           animations: {
                self.sportObjectNameLabel.alpha = 0
                self.chooseTimeButton.alpha = 0
                self.chooseDateButton.alpha = 0
                self.imageView.alpha = 0
                self.pleaseLabel.alpha = 0
                self.sheduleButton.alpha = 0
                self.timePicker.alpha = 0
            }, completion: { _ in
                self.addressLabelBottomSheduleStateConstaint.isActive = false
                self.addressLabelTopSavedStateConstaint.isActive = true
                self.bottomButtonBottomConstraint.isActive = false
                self.bottomButtonTopConstraint.isActive = true
                self.categoriesImageView.image = self.sportLongImage
                self.sheduleButton.setTitle("CLOSE", for: .normal)
                UIView.animate(withDuration: 0.2) {
                    self.sheduleButton.alpha = 1
                    self.goImageView.alpha = 1
                    self.categoriesImageView.alpha = 1
                    self.informationView.alpha = 1
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
            self.pleaseLabel.alpha = bottomButtonAlpha
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
            self.pleaseLabel.alpha = oppositAlpha
            self.layoutIfNeeded()
        }
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(imageView)
        addSubview(addressNameLabel)
        addSubview(sportObjectNameLabel)
        addSubview(availableTitlleLabel)
        addSubview(categoriesCollectionView)
        addSubview(sheduleButton)
        addSubview(chooseTimeButton)
        addSubview(chooseDateButton)
        addSubview(pleaseLabel)
        
        imageView.topAnchor.constraint(equalTo: imageView.superview!.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: imageView.superview!.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: imageView.superview!.rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: CGFloat(298).dp).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addressLabelBottomSheduleStateConstaint = addressNameLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10)
        addressLabelBottomSheduleStateConstaint.isActive = true
        addressLabelTopSavedStateConstaint = addressNameLabel.topAnchor.constraint(equalTo: goImageView.bottomAnchor, constant: 20)
        addressNameLabel.leftAnchor.constraint(equalTo: addressNameLabel.superview!.leftAnchor, constant: 16).isActive = true
        addressNameLabel.rightAnchor.constraint(equalTo: addressNameLabel.superview!.rightAnchor, constant: -16).isActive = true
        addressNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sportObjectNameLabel.bottomAnchor.constraint(equalTo: addressNameLabel.topAnchor, constant: -15).isActive = true
        sportObjectNameLabel.leftAnchor.constraint(equalTo: sportObjectNameLabel.superview!.leftAnchor, constant: 16).isActive = true
        sportObjectNameLabel.rightAnchor.constraint(equalTo: sportObjectNameLabel.superview!.rightAnchor, constant: -16).isActive = true
        sportObjectNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        availableTitlleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        availableTitlleLabel.leftAnchor.constraint(equalTo: availableTitlleLabel.superview!.leftAnchor).isActive = true
        availableTitlleLabel.rightAnchor.constraint(equalTo: availableTitlleLabel.superview!.rightAnchor).isActive = true
        availableTitlleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoriesCollectionView.topAnchor.constraint(equalTo: availableTitlleLabel.bottomAnchor, constant: 16).isActive = true
        categoriesCollectionView.leftAnchor.constraint(equalTo: categoriesCollectionView.superview!.leftAnchor, constant: 14).isActive = true
        categoriesCollectionView.rightAnchor.constraint(equalTo: categoriesCollectionView.superview!.rightAnchor, constant: -14).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: categoriesCollectionView.superview!.bottomAnchor, constant: 200).isActive = true
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        sheduleButton.widthAnchor.constraint(equalToConstant: CGFloat(271).dp).isActive = true
        sheduleButton.heightAnchor.constraint(equalToConstant: CGFloat(48).dp).isActive = true
        sheduleButton.centerXAnchor.constraint(equalTo: sheduleButton.superview!.centerXAnchor).isActive = true
        let bottomDistance = UIScreen.current.rawValue > 2 ? -CGFloat(163).dp : -(CustomTabBarController.tabbarBottomDistance + CustomTabBarController.tabbarHeight + 21).dp
        bottomButtonBottomConstraint = sheduleButton.bottomAnchor.constraint(equalTo: sheduleButton.superview!.bottomAnchor, constant: bottomDistance)
        bottomButtonBottomConstraint.isActive = true
        bottomButtonTopConstraint = sheduleButton.topAnchor.constraint(equalTo: informationView.bottomAnchor, constant: 38)
        sheduleButton.translatesAutoresizingMaskIntoConstraints = false
        
        setupSavedState()
    }
    
    private func sheduleStateConstraints() {
        chooseDateButton.topAnchor.constraint(equalTo: sportObjectNameLabel.bottomAnchor, constant: CGFloat(64).dp).isActive = true
        chooseDateButton.centerXAnchor.constraint(equalTo: chooseDateButton.superview!.centerXAnchor).isActive = true
        chooseDateButton.heightAnchor.constraint(equalToConstant: CGFloat(50).dp).isActive = true
        chooseDateButton.widthAnchor.constraint(equalToConstant: CGFloat(271).dp).isActive = true
        chooseDateButton.translatesAutoresizingMaskIntoConstraints = false
        
        chooseTimeTopConstraint = chooseTimeButton.topAnchor.constraint(equalTo: chooseDateButton.bottomAnchor, constant: CGFloat(17).dp)
        chooseTimeTopConstraint.isActive = true
        chooseTimeButton.heightAnchor.constraint(equalToConstant: CGFloat(50).dp).isActive = true
        chooseTimeButton.centerXAnchor.constraint(equalTo: chooseTimeButton.superview!.centerXAnchor).isActive = true
        chooseTimeButton.widthAnchor.constraint(equalToConstant: CGFloat(271).dp).isActive = true
        chooseTimeButton.translatesAutoresizingMaskIntoConstraints = false
        
        pleaseLabel.centerXAnchor.constraint(equalTo: pleaseLabel.superview!.centerXAnchor).isActive = true
        pleaseLabel.widthAnchor.constraint(equalToConstant: CGFloat(271).dp).isActive = true
        pleaseLabel.topAnchor.constraint(equalTo: chooseTimeButton.bottomAnchor, constant: 43).isActive = true
        pleaseLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func calendarViewConstraints() {
        calendarView.leftAnchor.constraint(equalTo: calendarView.superview!.leftAnchor, constant: 16).isActive = true
        calendarView.rightAnchor.constraint(equalTo: calendarView.superview!.rightAnchor, constant: -16).isActive = true
        calendarView.topAnchor.constraint(equalTo: chooseDateButton.bottomAnchor, constant: 5).isActive = true
        calendarHeightConstraint = calendarView.heightAnchor.constraint(equalToConstant: 200)
        calendarHeightConstraint.isActive = true
        calendarView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func timePickerConstraints() {
        timePicker.topAnchor.constraint(equalTo: chooseTimeButton.bottomAnchor, constant: 5).isActive = true
        timePickerHeightConstraint = timePicker.heightAnchor.constraint(equalToConstant: 150)
        timePickerHeightConstraint.isActive = true
        timePicker.centerXAnchor.constraint(equalTo: timePicker.superview!.centerXAnchor).isActive = true
        timePicker.widthAnchor.constraint(equalToConstant: 200).isActive = true
        timePicker.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSavedState() {
        addSubview(goImageView)
        addSubview(categoriesImageView)
        addSubview(informationView)
        addSubview(timePicker)
        
        goImageView.topAnchor.constraint(equalTo: goImageView.superview!.safeTopAnchor, constant: 0).isActive = true
        goImageView.leftAnchor.constraint(equalTo: goImageView.superview!.leftAnchor, constant: 16).isActive = true
        goImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let height = UIScreen.current.rawValue > 2 ? CGFloat(140).dp : CGFloat(115).dp
        categoriesImageView.topAnchor.constraint(equalTo: addressNameLabel.bottomAnchor, constant: 24).isActive = true
        categoriesImageView.leftAnchor.constraint(equalTo: categoriesImageView.superview!.leftAnchor, constant: 16).isActive = true
        categoriesImageView.rightAnchor.constraint(equalTo: categoriesImageView.superview!.rightAnchor, constant: -16).isActive = true
        categoriesImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        categoriesImageView.translatesAutoresizingMaskIntoConstraints = false
        
        informationView.topAnchor.constraint(equalTo: categoriesImageView.bottomAnchor, constant: 25).isActive = true
        informationView.leftAnchor.constraint(equalTo: informationView.superview!.leftAnchor, constant: 16).isActive = true
        informationView.rightAnchor.constraint(equalTo: informationView.superview!.rightAnchor, constant: -16).isActive = true
        informationView.heightAnchor.constraint(equalToConstant: CGFloat(75).dp).isActive = true
        informationView.translatesAutoresizingMaskIntoConstraints = false
    }

}
