//
//  SportObjectListViewController.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import AnchoredBottomSheet

class SportObjectListViewController: UIViewController, BottomSheetViewControllerDelegate  {
    func didDismiss() {
        print("click")
    }
    
    
    private let contentView = SportObjectListView()
    private let tableViewSheet = TableViewSheetView()
    private let presenter: ISportObjectListPresenter
    private var sportObjectSource: [SportObject] = []
    private let presentationAssembly: IPresentationAssembly
    private var afterSeeingVideoCompletion: (() -> Void)?
    private let sportType: SportType
    
//    weak var tableHeight: NSLayoutConstraint!
    
    
    private var viewState: SportObjectListViewState = .initial {
        didSet {
            contentView.setupView(for: viewState)
        }
    }
    let bottomView = TableViewSheetView()
    
    
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
        
//        tableHeight.constant = self.contentView.frame.height-64
//        contentView.sportObjectTableView.isScrollEnabled = false
//         //no need to write following if checked in storyboard
//        contentView.scroll.bounces = false
//        contentView.sportObjectTableView.bounces = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        addGoBackButton()
    }
    
    func showTableView() {
        
        let detailViewController = TableViewSheetController()
        let nav = UINavigationController(rootViewController: detailViewController)
        
        nav.modalPresentationStyle = .pageSheet
        nav.isModalInPresentation = true // add
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        present(nav, animated: true, completion: nil)
    }
    
    private func setupView() {
        contentView.categoryImageView.image = UIImage(named: sportType.bigImage)
        contentView.titleLabel.text = sportType.title
        contentView.backgroundColor = sportType.backgroundColor
        contentView.sportObjectTableView.backgroundColor = sportType.backgroundColor2
        contentView.sportObjectTableView.register(SportObjectTableViewCell.self, forCellReuseIdentifier: SportObjectTableViewCell.reuseID)
        contentView.sportObjectTableView.delegate = self
        contentView.sportObjectTableView.dataSource = self
        contentView.scroll.delegate = self
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
//
        if let sheet = vc.sheetPresentationController {
            sheet.preferredCornerRadius = 16.0
            sheet.detents = [.large(), .medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        navigationController?.present(vc, animated: true)
//        navigationController?.pushViewController(vc, animated: true)
    }
 
    func showObjects(sportsObjects: [SportObject]) {
        contentView.showLoader(toggle: false)
        contentView.sportObjectTableView.isHidden = false
        sportObjectSource = sportsObjects
        contentView.sportObjectTableView.reloadData()
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
    
    func connected(sender: UIButton!) {
        
    }
}

// MARK: - UITableView methods
extension SportObjectListViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
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
        
        guard let sportObject = sportObjectSource[safe: indexPath.row] else { return cell }
        cell.reserveButton.target(forAction: "connected", withSender: self)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Available arenas"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == self.contentView.scroll {
//            contentView.sportObjectTableView.isScrollEnabled = (self.contentView.scroll.contentOffset.y >= 200)
//        }
//
//        if scrollView == self.contentView.sportObjectTableView {
//            contentView.sportObjectTableView.isScrollEnabled = (contentView.sportObjectTableView.contentOffset.y > 0)
//        }
        
        if self.contentView.scroll.bounds.intersects(self.view.frame) == true {
            print("contentView.scroll.bounds.intersects(self.view.frame) == true")
         //the UIView is within frame, use the UIScrollView's scrolling.

            print(self.contentView.sportObjectTableView.contentOffset.y)
            if self.contentView.sportObjectTableView.contentOffset.y == 65.0 {
                //tableViews content is at the top of the tableView.

                self.contentView.sportObjectTableView.isUserInteractionEnabled = false
                self.contentView.sportObjectTableView.resignFirstResponder()
            print("using scrollView scroll")

            } else {

                //UIView is in frame, but the tableView still has more content to scroll before resigning its scrolling over to ScrollView.

                self.contentView.sportObjectTableView .isUserInteractionEnabled = true
                self.contentView.scroll.resignFirstResponder()
                print("using tableView scroll")
            }

        } else {
            print("contentView.scroll.bounds.intersects(self.view.frame) == false")

            //UIView is not in frame. Use tableViews scroll.

            self.contentView.sportObjectTableView.isUserInteractionEnabled = true
            self.contentView.scroll.resignFirstResponder()
            print("using tableView scroll")

        }
        
//        print(self.contentView.sportObjectTableView.contentOffset.y)
//
//        if self.contentView.sportObjectTableView.contentOffset.y > 65.0 {
//            self.contentView.scroll.resignFirstResponder()
//            self.contentView.sportObjectTableView.isScrollEnabled = false
//            self.contentView.scroll.isScrollEnabled = true
//        } else {
//            self.contentView.sportObjectTableView.isScrollEnabled = true
//            self.contentView.scroll.isScrollEnabled = false
//        }
        
//        if scrollView.bounds.contains(contentView.sportObjectTableView.tableHeaderView!.frame) {
//            self.contentView.sportObjectTableView.isScrollEnabled = true
//              }
//
//              if scrollView == self.contentView.sportObjectTableView {
//                  self.contentView.sportObjectTableView.isScrollEnabled = (self.contentView.sportObjectTableView.contentOffset.y > 0)
//              }
        
    }
}
