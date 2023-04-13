//
//  SportObjectListViewController.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import IronSource

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
        setupTableFooter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupNavBar()
    }
    
    private func setupView() {

        contentView.categoryImageView.image = UIImage(named: sportType.bigImage)
        contentView.titleLabel.text = sportType.title
        contentView.backgroundColor = sportType.backgroundColor
        contentView.tableView.backgroundColor = .clear
        contentView.tableView.register(SportObjectTableViewCell.self, forCellReuseIdentifier: SportObjectTableViewCell.reuseID)
        contentView.tableView.register(TransparentTableViewCell.self, forCellReuseIdentifier: TransparentTableViewCell.reuseID)
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        presenter.checkLocation()
        IronSource.setRewardedVideoDelegate(self)
    }
    
    func setupTableFooter() {
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: contentView.tableView.frame.size.width, height: 100))
//        view.roundCorners([.bottomLeft, .bottomRight], radius: 16.0)
        view.backgroundColor = sportType.backgroundColor2
        self.contentView.tableView.tableFooterView = view
    }
    
    private func setupNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = sportType.backgroundColor
//        UINavigationBar.appearance().tintColor = sportType.backgroundColor2
        self.navigationController?.navigationBar.tintColor = sportType.backgroundColor2
//        self.navigationController?.isToolbarHidden = true
        
        let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: sportType.backgroundColor2]
        navigationBarAppearance.buttonAppearance = buttonAppearance
        
        

        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
    }
    
    @objc
    func allowLocationButtonTapped() {
        guard
            let bundleId = Bundle.main.bundleIdentifier,
            let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
        else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func addGoBackButton() {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "ArrowLeft")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.sizeToFit()
//        button.tintColor = .AppCollors.yeallow
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
//        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
//        navigationItem.setLeftBarButtonItems([.], animated: <#T##Bool#>)
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
        
        
        vc.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {

            if let sheet = vc.sheetPresentationController {
                sheet.preferredCornerRadius = 16.0
                sheet.detents = [.large(), .medium()]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersGrabberVisible = true
                sheet.selectedDetentIdentifier = .large
            }
            
        } else {
            
            vc.modalPresentationStyle = .custom
//            vc.transitioningDelegate = self
        }
        navigationController?.present(vc, animated: true)

    }
 
    func showObjects(sportsObjects: [SportObject]) {
        contentView.showLoader(toggle: false)
        contentView.tableView.isHidden = false
        sportObjectSource = sportsObjects
        contentView.tableView.reloadData()
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
    
//    @objc func connected(sender: UIButton){
//        let buttonTag = sender.tag
//        presenter.sportObjectWasSelect(sportObject: sportObject)
//    }
}

// MARK: - UITableView methods
extension SportObjectListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentView.sectionBackgroundView.frame = contentView.tableView.rect(forSection: 1)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sportObject = sportObjectSource[safe: indexPath.row] else { return }
//              let cell = tableView.cellForRow(at: indexPath) as? SportObjectTableViewCell else { return }

        presenter.sportObjectWasSelect(sportObject: sportObject)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return sportObjectSource.count
        default: fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TransparentTableViewCell.reuseID, for: indexPath)
            cell.isSelected = false
            cell.isUserInteractionEnabled = false
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SportObjectTableViewCell.reuseID) as! SportObjectTableViewCell
            cell.object = sportObjectSource[safe: indexPath.row]
            cell.selectionStyle = .none
            cell.configure(type: sportType, indexPath: indexPath)
            return cell
        default: fatalError()
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = sportType.backgroundColor2
//        return view
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//       return 50
//   }
}


//extension SportObjectListViewController: UIViewControllerTransitioningDelegate {
//
//
//func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//    PresentationController(presentedViewController: presented, presenting: presenting)
//    }
//}

//class PresentationController: UIPresentationController {
//
//  let blurEffectView: UIVisualEffectView!
//  var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
//
//  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
//      let blurEffect = UIBlurEffect(style: .dark)
//      blurEffectView = UIVisualEffectView(effect: blurEffect)
//      super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
//      tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
//      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//      self.blurEffectView.isUserInteractionEnabled = true
//      self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
//  }
//
//  override var frameOfPresentedViewInContainerView: CGRect {
//      CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.4),
//             size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
//              0.6))
//  }
//
//  override func presentationTransitionWillBegin() {
//      self.blurEffectView.alpha = 0
//      self.containerView?.addSubview(blurEffectView)
//      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
//          self.blurEffectView.alpha = 0.7
//      }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
//  }
//
//  override func dismissalTransitionWillBegin() {
//      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
//          self.blurEffectView.alpha = 0
//      }, completion: { (UIViewControllerTransitionCoordinatorContext) in
//          self.blurEffectView.removeFromSuperview()
//      })
//  }
//
//  override func containerViewWillLayoutSubviews() {
//      super.containerViewWillLayoutSubviews()
//    presentedView!.roundCorners([.topLeft, .topRight], radius: 22)
//  }
//
//  override func containerViewDidLayoutSubviews() {
//      super.containerViewDidLayoutSubviews()
//      presentedView?.frame = frameOfPresentedViewInContainerView
//      blurEffectView.frame = containerView!.bounds
//  }
//
//  @objc func dismissController(){
//      self.presentedViewController.dismiss(animated: true, completion: nil)
//  }
//}
//
//extension UIView {
//  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
//      let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
//                              cornerRadii: CGSize(width: radius, height: radius))
//      let mask = CAShapeLayer()
//      mask.path = path.cgPath
//      layer.mask = mask
//  }
//}
