//
//  AskLocationViewController.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import CoreLocation
import NotificationCenter

class AskPermissionsViewController: UIViewController, DeviceLocationServiceDelegate, UNUserNotificationCenterDelegate {
    
    private let contentView = AskPermissionsView()
    private let presentationAssembly: IPresentationAssembly
    private let userInfoService: ISensentiveInfoService
    private let permissionsType: PermissionsType
    private let locationService: IDeviceLocationService
    
    init(
        presentationAssembly: IPresentationAssembly,
        type: PermissionsType,
        locationService: IDeviceLocationService,
        userInfoService: ISensentiveInfoService
    ) {
        self.presentationAssembly = presentationAssembly
        self.contentView.causeLabel.text = type.title
        self.contentView.pushIconView.image = type.image
        self.contentView.progressView.progress = type.progress
        self.contentView.skipButton.setTitle(type.skip, for: .normal)
        self.contentView.secondCauseLabel.text = type.secondTitle
        self.permissionsType = type
        self.locationService = locationService
        self.userInfoService = userInfoService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc
    func allowTapped() {
        switch permissionsType {
        case .push:
            getNotificationSettings { [weak self] (success) -> Void in
                if success{
                    self?.userInfoService.changeAskPushValue()
                    DispatchQueue.main.async {
                        self?.skipTapped()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.skipTapped()
                    }
                }
            }
        case .location:
            self.locationService.delegate = self
            locationService.requestLocationUpdates()
        }
    }
    
    @objc
    func skipTapped() {
        userInfoService.changeAskPushValue()
        switch permissionsType {
        case .push(let appWay, let link):
            if appWay == .web, let link {
                let webView = presentationAssembly.webViewController(site: link, title: nil)
                navigationController?.pushViewController(webView, animated: true)
            } else {
                let enterVC = presentationAssembly.enterScreen()
                navigationController?.pushViewController(enterVC, animated: true)
            }
        case .location:
            goToTabbar()
        }
    }
    
    func getNotificationSettings(_ completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard granted else { return completion(false) }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                completion(true)
            }
        }
    }
    
//    private func registerForPushNotifications(completionHandler: @escaping () -> Void) {
//      UNUserNotificationCenter.current()
//        .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
//            completionHandler()
//            guard granted else { return }
//            self?.getNotificationSettings()
//        }
//    }
//
//    private func getNotificationSettings() {
//      UNUserNotificationCenter.current().getNotificationSettings { settings in
//        print("Notification settings: \(settings)")
//          guard settings.authorizationStatus == .authorized else { return }
//          DispatchQueue.main.async {
//            UIApplication.shared.registerForRemoteNotifications()
//          }
//      }
//    }
    
    private func goToTabbar() {
        let viewController = presentationAssembly.tabbarController()
        if #available(iOS 13.0, *) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        } else {
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(viewController)
        }
    }
    
    func didChangeLocationStatus() {
        switch self.locationService.locationStatus {
        case .authorizedWhenInUse, .authorizedAlways, .denied:
            skipTapped()
        default:
            break
        }
    }
    
    func loacationDidChange(location: CLLocationCoordinate2D?) {}
}
