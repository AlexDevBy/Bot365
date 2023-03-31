//
//  LaunchScreenViewController.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import Alamofire

class LaunchScreenViewController: UIViewController {
    
    private let contentView: LaunchScreenView
    private let networkService: INetworkService
    private let presentationAssembly: IPresentationAssembly
    private let userInfoService: ISensentiveInfoService
    private let purchasesService: IProductService
    
    init(networkService: INetworkService,
         presentationAssembly: IPresentationAssembly,
         userInfoService: ISensentiveInfoService,
         purchasesService: IProductService,
         contentView: LaunchScreenView
    ) {
        self.contentView = contentView
        self.networkService = networkService
        self.userInfoService = userInfoService
        self.presentationAssembly = presentationAssembly
        self.purchasesService = purchasesService
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
        initPurchases()
        checkCountry()
    }
    
    private func initPurchases() {
        purchasesService.purchasesInit()
    }
    
    private func checkCountry() {
        DispatchQueue.global(qos: .background).async {
            self.getCountry(ip: nil)
            self.getCountryCode(ip: nil)
        }
    }
    
    private func getCountry(ip: String?) {
        networkService.getCountry(ip: ip) { [ weak self ] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let tab):
                    strongSelf.routeToNextScreen(appWay: tab)
                case .failure(let error):
                    strongSelf.displayMsg(title: nil, msg: error.textToDisplay)
                }
            }
        }
    }
    
    private func getCountryCode(ip: String?) {
        networkService.getCountryCode(ip: ip) { [ weak self ] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    guard let userinfo = self?.userInfoService else { return }
                    userinfo.saveCountryCode(code: result.countryCode)
                    print(result)
                case .failure(let error):
                    strongSelf.displayMsg(title: nil, msg: error.textToDisplay)
                }
            }
        }
    }
    
    
    private func routeToNextScreen(appWay: AppWayByCountry) {
        switch appWay {
        case .toApp:
            guard userInfoService.wasPushAsked()
            else {
                let enterVC = presentationAssembly.askPermissionsScreen(permissionType: .push(appWay: .toApp, link: nil))
                setWindowRoot(enterVC)
                return
            }
            homeOrEnterScreen()
        case .web:
            loadLink()
        }
    }
    
    private func loadLink() {
        networkService.loadLink { [ weak self ] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let link):
                    guard strongSelf.userInfoService.wasPushAsked()
                    else {
                        let enterVC = strongSelf.presentationAssembly.askPermissionsScreen(permissionType: .push(appWay: .web, link: link))
                        strongSelf.setWindowRoot(enterVC)
                        return
                    }
                    let webview = strongSelf.presentationAssembly.webViewController(site: link, title: nil)
                    strongSelf.setWindowRoot(webview)
                case .failure(let failure):
                    strongSelf.displayMsg(title: nil, msg: failure.textToDisplay)
                }
            }
        }
    }
    
    private func homeOrEnterScreen() {
        guard
            userInfoService.isUserInApp() == false
        else {
            let tabbarController = presentationAssembly.tabbarController()
            setWindowRoot(tabbarController)
            return
        }
        let enterVC = presentationAssembly.enterScreen()
        setWindowRoot(enterVC)
    }
    
    private func setWindowRoot(_ viewController: UIViewController) {
        if #available(iOS 13.0, *) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        } else {
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(viewController)
        }
    }
}
