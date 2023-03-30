//
//  SettingsPresenter.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit

protocol ISettingsPresenter: AnyObject {
    func attachView(view: ISettingsView)
    func getDataSource() -> [SettingType]
    func settingWasTapped(type: SettingType)
}

protocol ISettingsView: AnyObject {
    func routeToWebSite(_ site: String)
    func routeToReminders()
    func showMessage(text: String)
    func reloadTable(types: [SettingType])
    func showLoader()
    func hideLoader()
}

class SettingsPresenter: ISettingsPresenter {
    
    private let networkService: INetworkService
    private let userInfoService: ISensentiveInfoService
    private let presentationAssembly: IPresentationAssembly
    private let purchasesService: IProductService
    private let notificationCenter = NotificationCenter.default
    private weak var view: ISettingsView?
    
    init(networkService: INetworkService,
         userInfoService: ISensentiveInfoService,
         presentationAssembly: IPresentationAssembly,
         productService: IProductService
    ) {
        self.networkService = networkService
        self.userInfoService = userInfoService
        self.presentationAssembly = presentationAssembly
        self.purchasesService = productService
    }
    
    func attachView(view: ISettingsView) {
        self.view = view
        addNotification()
    }
    
    func addNotification() {
        notificationCenter.addObserver(self,
                                       selector: #selector(reloadSettings),
                                       name: .addsOffSuccess,
                                       object: nil)
    }
    
    func postNotification() {
        notificationCenter
            .post(
                name: .addsOffSuccess,
                object: nil
            )
    }
    
    @objc
    private func reloadSettings() {
        DispatchQueue.main.async {
            self.view?.reloadTable(types: self.getDataSource())
        }
    }
    
    func getDataSource() -> [SettingType] {
        var source: [SettingType] = [
//            SettingType.myTrains,
            SettingType.terms,
            SettingType.privacy,
            SettingType.feedback,
            SettingType.rateUs,
            SettingType.restorePurchases,
            SettingType.deleteAccount
        ]
        if !userInfoService.isPremiumActive() {
            source.insert(SettingType.turnOffAdds, at: 0)
        }
        return source
    }
    
    func settingWasTapped(type: SettingType) {
        switch type {
        case .myTrains:
            view?.routeToReminders()
        case .turnOffAdds:
            buyRemoveAdd()
        case .rateUs:
            let appID = 6444889904 // Из apple connect взял
            let urlStr = "https://itunes.apple.com/app/id\(appID)?action=write-review"
            view?.routeToWebSite(urlStr)
        case .feedback:
            view?.routeToWebSite("https://bot365.tech/#contact")
        case .privacy:
            view?.routeToWebSite("https://bot365.tech/#privacy")
        case .terms:
            view?.routeToWebSite("https://bot365.tech/#eula")
        case .restorePurchases:
            restorePurchases()
        case .deleteAccount:
            deleteAccount()
        }
    }
    
    func deleteAccount() {
        networkService.deleteProfile { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result {
                case .success(_):
                    strongSelf.revokeAppleToken()
                    strongSelf.goToEnterScreen()
                case .failure(_):
                    strongSelf.goToEnterScreen()
                }
            }
        }
    }
    
    private func revokeAppleToken() {
        guard let appleToken = userInfoService.getAppleToken() else { return }
        networkService.revokeAppleToken(token: appleToken, completion: { _ in })
    }
    
    func buyRemoveAdd() {
        view?.showLoader()
        purchasesService.buyAddsOff { [ weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoader()
                guard let strongSelf = self else { return }
                switch result {
                case .success(_):
                    strongSelf.sendToSucceedPurchases()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func restorePurchases() {
        purchasesService.restorePurchases { [weak self] result in
            switch result {
            case .success:
                self?.sendToSucceedPurchases()
            case .failure(let error):
                self?.view?.showMessage(text: error.localizedDescription)
            }
        }
    }
    
    private func sendToSucceedPurchases() {
        networkService.addPremium { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let succesResult):
                    if succesResult.0 {
                        strongSelf.userInfoService.savePremium()
                        strongSelf.view?.showMessage(text: succesResult.1)
                        strongSelf.postNotification()
                    }
                case .failure(let error):
                    strongSelf.view?.showMessage(text: error.localizedDescription)
                }
            }
        }
    }
    
    private func goToEnterScreen() {
        userInfoService.deleteAllInfo { _ in
            if #available(iOS 13.0, *) {
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(presentationAssembly.enterScreen())
            } else {
                (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(presentationAssembly.enterScreen())
            }
        }
    }
    
    deinit {
        notificationCenter
            .removeObserver(self,
                            name: .addsOffSuccess ,
                            object: nil)
    }
}
