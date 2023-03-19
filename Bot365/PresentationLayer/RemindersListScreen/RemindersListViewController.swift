//
//  RemindersListViewController.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit

class RemindersListViewController: UIViewController {
    
    private let contentView = RemindersListView()
    private var events: [SportEvent] = []
    private let presenter: ICalendarPresenter
    
    init(presenter: ICalendarPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
        presenter.attachView(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getMyStaidums()
    }
    
    private func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        contentView.tableView.register(ReminderSportObjectTableViewCell.self, forCellReuseIdentifier: ReminderSportObjectTableViewCell.reuseID)
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }

}

// MARK: - View
extension RemindersListViewController: ICalendarView {
    func setEvents(events: [SportEvent]) {
        self.events = events
        contentView.tableView.reloadSections(IndexSet([0]), with: .automatic)
        contentView.showHideEmptyReminders(show: events.isEmpty)
    }
    
    private func askAlert(title: String?,
                          msg: String,
                          style: UIAlertController.Style = .alert,
                          completionHandler: (()->())? = nil) {
        let ac = UIAlertController.init(title: title,
                                        message: msg, preferredStyle: style)
        ac.addAction(UIAlertAction.init(title: "Yes",
                                        style: .default,
                                        handler: { _ in completionHandler?()
        }))
        ac.addAction(UIAlertAction.init(title: "No",
                                        style: .default, handler: { (_) in
        }))
        DispatchQueue.main.async {
            ac.show()
        }
    }
}

// MARK: - UITableview methods
extension RemindersListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReminderSportObjectTableViewCell.reuseID) as! ReminderSportObjectTableViewCell
        cell.event = events[safe: indexPath.row]
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: Delegates
extension RemindersListViewController: SportsObjectTableViewCellDelegate {
    func deleteEventTappped(with id: String) {
        askAlert(title: "Do you want to delete reminder?", msg: "") {
            self.presenter.removeEvent(with: id)
        }
    }
}
