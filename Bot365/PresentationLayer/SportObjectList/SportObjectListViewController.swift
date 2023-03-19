//
//  SportObjectListViewController.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit

class SportObjectListViewController: UIViewController {
    
    private let contentView = SportObjectListView()
    private let presenter: ISportObjectListPresenter
    private var sportObjectSource: [SportObject] = []
    private let presentationAssembly: IPresentationAssembly
    private var afterSeeingVideoCompletion: (() -> Void)?
    private let sportType: SportType
    private var viewState: SportObjectListViewState = .initial {
        didSet {
            contentView.setupView(for: viewState)
        }
    }
    
    init(
        presenter: ISportObjectListPresenter,
        sportType: SportType,
        presentationAssembly: IPresentationAssembly
    ) {
        self.presentationAssembly = presentationAssembly
        self.presenter = presenter
        self.sportType = sportType
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
        contentView.showLoader(toggle: true)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        addGoBackButton()
    }
    
    private func setupView() {
        contentView.categoryImageView.image = UIImage(named: sportType.longImage)
        contentView.sportObjectTableView.register(SportObjectTableViewCell.self, forCellReuseIdentifier: SportObjectTableViewCell.reuseID)
        contentView.sportObjectTableView.delegate = self
        contentView.sportObjectTableView.dataSource = self
        presenter.checkLocation()
        IronSource.setRewardedVideoDelegate(self)
    }
    
    @objc
    func allowLocationButtonTapped() {
        guard
            let bundleId = Bundle.main.bundleIdentifier,
            let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
        else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc
    private func addGoBackButton() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ArrowLeft")?.withRenderingMode(.alwaysOriginal), for: .normal)
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

// MARK: - IronSource video delegate
extension SportObjectListViewController: ISRewardedVideoDelegate {
    func rewardedVideoHasChangedAvailability(_ available: Bool) {
        print("video is available == \(available)")
    }
    
    func didReceiveReward(forPlacement placementInfo: ISPlacementInfo!) {}
    
    func rewardedVideoDidFailToShowWithError(_ error: Error!) {}
    
    func rewardedVideoDidOpen() {}
    
    func rewardedVideoDidStart() {}
    
    func rewardedVideoDidEnd() {
        afterSeeingVideoCompletion?()
    }
    
    func didClickRewardedVideo(_ placementInfo: ISPlacementInfo!) {
        
    }
    
    // Iron Source delegate
    public func rewardedVideoDidClose() {
        afterSeeingVideoCompletion?()
    }
}

// MARK: - View
extension SportObjectListViewController: ISportObjectListView {
    func showError(text: String) {
        viewState = .error(text)
    }
    
    func showAdd(completionHandler: @escaping () -> Void) {
        self.afterSeeingVideoCompletion = completionHandler
        IronSource.showRewardedVideo(with: self, placement: nil)
    }
    
    func routeToCreateReminder(sportObject: SportObject) {
        let vc = presentationAssembly.createReminderScreen(sportObject: sportObject)
        navigationController?.pushViewController(vc, animated: true)
    }
 
    func showObjects(sportsObjects: [SportObject]) {
        contentView.showLoader(toggle: false)
        sportObjectSource = sportsObjects
        contentView.sportObjectTableView.reloadSections(IndexSet([0]), with: .automatic)
        guard sportsObjects.isEmpty else { return }
        contentView.errorLabel.text = "Sorry, there are no such places near you"
    }
    
    func showLocationState(isAllowed: Bool) {
        if isAllowed {
            switch viewState {
            case .locationExist:
                break
            default:
                viewState = .locationExist
            }
        } else {
            viewState = .noLocation
        }
    }
}

// MARK: - UITableView methods
extension SportObjectListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sportObject = sportObjectSource[safe: indexPath.row] else { return }
        presenter.sportObjectWasSelect(sportObject: sportObject)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sportObjectSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SportObjectTableViewCell.reuseID) as! SportObjectTableViewCell
        cell.object = sportObjectSource[safe: indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
}
