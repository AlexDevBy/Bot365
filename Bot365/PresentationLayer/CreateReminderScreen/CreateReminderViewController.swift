//
//  LocationViewController.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import FSCalendar

class CreateReminderViewController: UIViewController {
    
    private let contentView = CreateReminderView()
    private var categoriesSource: [CategoriesModels] = []
    private let presenter: ILocationPresenter
    private var isDateCalendarShow: Bool = false
    private var isTimePickerShow: Bool = false
    private var allowToSaveIndicator: Bool = false
    private var viewState: LocationScreenViewState = .initial {
        didSet {
            contentView.changeView(for: viewState)
        }
    }
    
    init(
        presenter: ILocationPresenter
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
        presenter.attachView(view: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.sportLongImage = UIImage(named: presenter.sportObject.type.longImage)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addGoBackButton()
        navigationController?.navigationBar.tintColor = .AppCollors.yeallow
    }
    
    private func setupView() {
        viewState  = .initial
        contentView.imageView.image = UIImage(named: presenter.sportObject.type.bigImage)
        contentView.addressNameLabel.text = presenter.sportObject.address
        contentView.sportObjectNameLabel.text = presenter.sportObject.name
        contentView.calendarView.delegate = self
        categoriesSource = presenter.getCategories()
        contentView.categoriesCollectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: CategoriesCollectionViewCell.reuseID)
        contentView.categoriesCollectionView.dataSource = self
        contentView.categoriesCollectionView.delegate = self
    }
    
    @objc
    func bottomButtonTapped() {
        switch viewState {
        case .initial:
            viewState = .shedule
        case .shedule:
            guard allowToSaveIndicator else { return }
            presenter.createReminder()
        case .sheduleSaved:
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc
    func dateButtonTapped() {
        isTimePickerShow = false
        contentView.showTimePicker(show: isTimePickerShow)
        isDateCalendarShow.toggle()
        contentView.showCalendar(show: isDateCalendarShow)
    }
    
    @objc
    func timeButtonTapped() {
        isDateCalendarShow = false
        contentView.showCalendar(show: isDateCalendarShow)
        isTimePickerShow.toggle()
        contentView.showTimePicker(show: isTimePickerShow)
    }
    
    @objc
    func startTimeDiveChanged(sender: UIDatePicker) {
        contentView.chooseTimeButton.setTitle(sender.date.toString("HH:mm"), for: .normal)
        let gregorian = Calendar.current
        let components = gregorian.dateComponents([.hour, .minute], from: sender.date)
        guard let hours = components.hour, let minutes = components.minute else { return }
        presenter.setHoursAndMinutes(hours: hours, minuts: minutes)
    }
    
    @objc
    private func addGoBackButton() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ArrowLeft")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.sizeToFit()
        button.tintColor = .AppCollors.yeallow
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    @objc
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MMARK: - View
extension CreateReminderViewController: ILocationView {
    func allowToSave() {
        allowToSaveIndicator = true
        contentView.sheduleButton.alpha = 1
    }
    
    func showSavedNotificationState() {
        viewState = .sheduleSaved
    }
    
    func showMessage(error: String) {
        displayMsgWithoutActions(title: "Что-то пошло не так", msg: error)
    }
}

// MARK: - UICollectionView methods
extension CreateReminderViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - CreateReminderView.Constants.interItemSpacing, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.reuseID, for: indexPath) as! CategoriesCollectionViewCell
        cell.categoriesModel = categoriesSource[safe: indexPath.row]
        return cell
    }
}

// MARK: - Delegates
extension CreateReminderViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        presenter.setDate(date)
        contentView.chooseDateButton.setTitle(date.toString(), for: .normal)
    }
}
