//
//  EnterViewController.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import AuthenticationServices

class EnterViewController: UIViewController {
    
    private let contentView = EnterView()
    private let presentationAssembly: IPresentationAssembly
    private let userInfoService: ISensentiveInfoService
    private let networkService: INetworkService
    
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
    
    private func setupView() {
        contentView.signInHandler = {
            let pushPermission = self.presentationAssembly.askPermissionsScreen(permissionType: .location)
            self.navigationController?.pushViewController(pushPermission, animated: true)
            
//            let provider = ASAuthorizationAppleIDProvider()
//            let request = provider.createRequest()
//            request.requestedScopes = [.email]
//
//            let controller = ASAuthorizationController(authorizationRequests: [request])
//            controller.delegate = self
//            controller.presentationContextProvider = self
//            controller.performRequests()
        }
    }
    
    private func makeAppleAuth(code: String) {
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
        networkService.makeAuth(token: token) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result {
                case .success(let token):
                    guard token.count > 3 else { return }
                    strongSelf.userInfoService.saveToken(token: token) { _ in
                        let pushPermission = strongSelf.presentationAssembly.askPermissionsScreen(permissionType: .location)
                        strongSelf.navigationController?.pushViewController(pushPermission, animated: true)
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
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
            print(codeString)
            makeAppleAuth(code: codeString)
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
