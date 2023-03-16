//
//  SettingsViewController.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 22.11.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let contentView: Settingsview
    private var settingsDataSource: [SettingType] = []
    private let presenter: ISettingsPresenter
    private let loaderViewController: LoaderViewController
    private let presentationAssembly: IPresentationAssembly

    init(view: Settingsview,
         presenter: SettingsPresenter,
         presentationAssembly: IPresentationAssembly
    ) {
        self.contentView = view
        self.presenter = presenter
        self.presentationAssembly = presentationAssembly
        self.loaderViewController = presentationAssembly.getLoaderScreen()
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
        view.backgroundColor = .white
        settingsDataSource = presenter.getDataSource()
        setupView()
    }

    private func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        contentView.tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseID)
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }

}

// MARK: - View
extension SettingsViewController: ISettingsView {
    func routeToReminders() {
        (tabBarController as? CustomTabBarController)?.showScreen(.calendar)
    }
    
    func reloadTable(types: [SettingType]) {
        self.settingsDataSource = types
        contentView.tableView.reloadData()
    }
    
    func showMessage(text: String) {
        displayMsg(title: nil, msg: text)
    }
    
    func routeToWebSite(_ site: String) {
        navigationController?.pushViewController(presentationAssembly.webViewController(site: site, title: nil), animated: true)
    }
    
    func showLoader() {
        tabBarController?.present(loaderViewController, animated: false)
    }
    
    func hideLoader() {
        loaderViewController.hideLoader()
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = settingsDataSource[safe: indexPath.row] else { return }
        presenter.settingWasTapped(type: type)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseID) as! SettingsTableViewCell
        cell.settingsModel = settingsDataSource[safe: indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
