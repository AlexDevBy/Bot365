//
//  AppInfoService.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation

protocol ISensentiveInfoService: AnyObject {
    func getToken() -> String?
    func getPushToken() -> String?
    func saveToken(token: String, completionHandler: FinishedCompletionHandler)
    func saveAppleToken(token: String)
    func saveNotificationToken(token: String)
    func deleteAllInfo(completionBlock: FinishedCompletionHandler)
    func isUserInApp() -> Bool
    func savePremium()
    func isPremiumActive() -> Bool
    func getAppleToken() -> String?
    func wasPushAsked() -> Bool
    func changeAskPushValue()
    func saveCountryCode(code: String)
    func getCountryCode() -> String?
}

class AppInfoService: ISensentiveInfoService {
    
    private let secureStorage: ISecureStorage
    private let appSettingsStorage: IUserDefaultsSettings

    init(
        secureStorage: ISecureStorage,
        userInfoStorage: IUserDefaultsSettings
    ) {
        self.secureStorage = secureStorage
        self.appSettingsStorage = userInfoStorage
    }
    
    func getToken() -> String? {
        secureStorage.getToken()
    }
    
    func getPushToken() -> String? {
        secureStorage.getPushToken()
    }
    
    func saveToken(token: String, completionHandler: FinishedCompletionHandler) {
        changeUserInAppValue(isUserInApp: true)
        secureStorage.saveToken(token: token, completionHandler: completionHandler)
    }
    
    func saveAppleToken(token: String) {
        secureStorage.saveAppleToken(token: token)
    }
    
    func deleteAllInfo(completionBlock: (Bool) -> ()) {
        changeUserInAppValue(isUserInApp: false)
        secureStorage.deleteAllInfo(completionBlock: completionBlock)
    }
    
    func isUserInApp() -> Bool {
        return appSettingsStorage.getUserInAppValue()
    }
    
    func savePremium() {
        secureStorage.savePremium()
    }
    
    func isPremiumActive() -> Bool {
        secureStorage.premiumIsActive()
    }
    
    func getAppleToken() -> String? {
        secureStorage.getAppleToken()
    }
    
    private func changeUserInAppValue(isUserInApp: Bool) {
        appSettingsStorage.changeUserInAppValue(on: isUserInApp)
    }
    
    func saveNotificationToken(token: String) {
        secureStorage.savePushToken(token: token)
    }
    
    func saveCountryCode(code: String) {
        secureStorage.saveCountryCode(code: code)
    }
    
    func getCountryCode() -> String? {
        secureStorage.getCountryCode()
    }
    
    
    func wasPushAsked() -> Bool {
        appSettingsStorage.getAskPushValue()
    }
    
    func changeAskPushValue() {
        appSettingsStorage.changePushAsked(value: true)
    }
}
