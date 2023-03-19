//
//  PresentationAssembly.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation
import UIKit

protocol IPresentationAssembly {
    func enterScreen() -> EnterViewController
    func askPermissionsScreen(permissionType: PermissionsType) -> AskPermissionsViewController
    func tabbarController() -> CustomTabBarController
    func sportObjectList(sportType: SportType) -> SportObjectListViewController
    func webViewController(site: String, title: String?) -> WebViewViewController
    func calendarScreen() -> RemindersListViewController
    func settingsScreen() -> SettingsViewController
    func homeScreen() -> HomeViewController
    func createReminderScreen(sportObject: SportObject) -> CreateReminderViewController
    func getCountryCheckScreen() -> LaunchScreenViewController
    func getLoaderScreen() -> LoaderViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    let serviceAssembly: IServiceAssembly
    
    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func getCountryCheckScreen() -> LaunchScreenViewController {
        LaunchScreenViewController(networkService: serviceAssembly.networkService,
                                   presentationAssembly: self,
                                   userInfoService: serviceAssembly.userInfoService,
                                   purchasesService: serviceAssembly.purchasesService,
                                   contentView: LaunchScreenView())
    }
    
    func enterScreen() -> EnterViewController {
        EnterViewController(presentationAssembly: self,
                            userInfoService: serviceAssembly.userInfoService,
                            networkService: serviceAssembly.networkService)
    }
    
    func webViewController(site: String, title: String? = nil) -> WebViewViewController {
        WebViewViewController(site: site, title: title)
    }
    
    func askPermissionsScreen(permissionType: PermissionsType) -> AskPermissionsViewController {
        AskPermissionsViewController(presentationAssembly: self,
                                     type: permissionType,
                                     locationService: serviceAssembly.deviceLocationService,
                                     userInfoService: serviceAssembly.userInfoService)
    }
    
    func calendarScreen() -> RemindersListViewController {
        RemindersListViewController(presenter: RemindersListPresenter(databaseService: serviceAssembly.databaseService))
    }
    
    func settingsScreen() -> SettingsViewController {
        SettingsViewController(view: Settingsview(),
                               presenter: SettingsPresenter(networkService: serviceAssembly.networkService,
                                                            userInfoService: serviceAssembly.userInfoService,
                                                            presentationAssembly: self,
                                                            productService: serviceAssembly.purchasesService),
                               presentationAssembly: self)
    }
    
    func homeScreen() -> HomeViewController {
        HomeViewController(presenter: HomeScreenPresenter(networkService: serviceAssembly.networkService,
                                                          userInfoService: serviceAssembly.userInfoService,
                                                          presentationAssembly: self,
                                                          productService: serviceAssembly.purchasesService),
                           presentationAssembly: self)
    }
    
    func tabbarController() -> CustomTabBarController {
        CustomTabBarController(tabBar: CustomTabBar(presentationAssembly: self))
    }
    
    func createReminderScreen(sportObject: SportObject) -> CreateReminderViewController {
        CreateReminderViewController(
            presenter: CreateReminderPresenter(
                databaseService: serviceAssembly.databaseService,
                sportObject: sportObject)
        )
    }
    
    func sportObjectList(sportType: SportType) -> SportObjectListViewController {
        SportObjectListViewController(
            presenter: SportObjectListPresenter(
                locationService: serviceAssembly.deviceLocationService,
                databaseService: serviceAssembly.databaseService,
                networkService: serviceAssembly.networkService,
                settingsService: serviceAssembly.userInfoService,
                sportType: sportType),
            sportType: sportType,
            presentationAssembly: self)
    }

    func getLoaderScreen() -> LoaderViewController {
        let loaderVC = LoaderViewController()
        loaderVC.modalPresentationStyle = .overCurrentContext
        return loaderVC
    }
    
}
