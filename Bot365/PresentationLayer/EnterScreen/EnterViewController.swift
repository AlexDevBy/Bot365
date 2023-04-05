//
//  EnterViewController.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import AuthenticationServices
import CoreLocation

class EnterViewController: UIViewController {
    
    private let contentView = EnterView()
    private let presentationAssembly: IPresentationAssembly
    private let userInfoService: ISensentiveInfoService
    private let networkService: INetworkService
    let current = UNUserNotificationCenter.current()
    
    init(
        presentationAssembly: IPresentationAssembly,
        userInfoService: ISensentiveInfoService,
        networkService: INetworkService
    ) {
        self.presentationAssembly = presentationAssembly
        self.userInfoService = userInfoService
        self.networkService = networkService
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupView() {
        contentView.signInHandler = {
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
    
    private func makeAppleAuth(code: String) {
        print("makeAppleAuth code - \(code)")
        networkService.makeAuth(code: code) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result {
                case .success(let authModel):
                    guard authModel.accessToken.count > 3 else { return }
                    strongSelf.userInfoService.saveAppleToken(token: authModel.accessToken)
                    strongSelf.makeAuth(token: authModel.accessToken)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func makeAuth(token: String) {
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                self.makeAuthIfPushDisabled(token: token)
            } else if settings.authorizationStatus == .denied {
                self.makeAuthIfPushDisabled(token: token)
            } else if settings.authorizationStatus == .authorized {
                self.makeAuthIfPushEnabled(token: token)
            }
        })
    }
    
    private func makeAuthIfPushEnabled(token: String) {
        guard let countryCode = self.userInfoService.getCountryCode() else { return }
              let pushToken = self.userInfoService.getPushToken() ?? "noToken"
        print("appleToken: \(token), pushToken: \(pushToken), countryCode: \(countryCode)")
        self.networkService.makeAuth(token: token, pushToken: pushToken, countryCode: countryCode) { [weak self] result in
            DispatchQueue.main.async { [self] in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let token):
                    strongSelf.userInfoService.saveToken(token: token) { _ in
                        switch CLLocationManager.authorizationStatus() {
                        case .notDetermined:
                            guard let pushPermission = self?.presentationAssembly.askPermissionsScreen(permissionType: .location) else { return }
                            self?.navigationController?.pushViewController(pushPermission, animated: true)
                            print("notDetermined")
                        case .denied, .authorizedAlways, .restricted, .authorizedWhenInUse:
                            guard let tabbarController = self?.presentationAssembly.tabbarController() else { return }
                            self?.setWindowRoot(tabbarController)
                            
                        @unknown default:
                            print("error with location")
                        }
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
    
    private func makeAuthIfPushDisabled(token: String) {
        guard let countryCode = self.userInfoService.getCountryCode() else { return }
              let pushToken = self.userInfoService.getPushToken() ?? "noToken"
        print("appleToken: \(token), pushToken: \(pushToken), countryCode: \(countryCode)")
        self.networkService.makeAuthIfPushDis(token: token) { [weak self] result in
            DispatchQueue.main.async { [self] in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let token):
                    strongSelf.userInfoService.saveToken(token: token) { _ in
                        switch CLLocationManager.authorizationStatus() {
                        case .notDetermined:
                            guard let pushPermission = self?.presentationAssembly.askPermissionsScreen(permissionType: .location) else { return }
                            self?.navigationController?.pushViewController(pushPermission, animated: true)
                            print("notDetermined")
                        case .denied, .authorizedAlways, .restricted, .authorizedWhenInUse:
                            guard let tabbarController = self?.presentationAssembly.tabbarController() else { return }
                            self?.setWindowRoot(tabbarController)
                            
                        @unknown default:
                            print("error with location")
                        }
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
    
    private func setWindowRoot(_ viewController: UIViewController) {
        if #available(iOS 13.0, *) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        } else {
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(viewController)
        }
    }
    
}

extension EnterViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("failed")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let credentiontials as ASAuthorizationAppleIDCredential:
            guard
                let code = credentiontials.authorizationCode,
                let codeString = String(data: code, encoding: .utf8)
            else { return }
            print(credentiontials.email)
            print(codeString)
            makeAppleAuth(code: codeString)
            
//            switch CLLocationManager.authorizationStatus() {
//            case .notDetermined:
//                 let pushPermission = self.presentationAssembly.askPermissionsScreen(permissionType: .location)
//                self.navigationController?.pushViewController(pushPermission, animated: true)
//                print("notDetermined")
//            case .denied, .authorizedAlways, .restricted, .authorizedWhenInUse:
//                let tabbarController = self.presentationAssembly.tabbarController()
//                self.setWindowRoot(tabbarController)
//
//            @unknown default:
//                print("error with location")
//            }
            
        default:
            break
        }
    }
}

extension EnterViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}
