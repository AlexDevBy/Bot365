//
//  AppDelegate.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, ISInitializationDelegate {
    
    private enum Constants {
        static let IronAppKey = "1852f50bd"
    }

    var window: UIWindow?
    let rootAssembly = RootAssembly()
    let notificationCenter = UNUserNotificationCenter.current()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        notificationCenter.delegate = self
        setupFrameworks()
        if #available(iOS 13, *) { }
        else { createStartView(window: window ?? UIWindow(frame: UIScreen.main.bounds)) }
        return true
    }

    
    // Iron Source
    private func setupFrameworks() {
        IronSource.initWithAppKey(Constants.IronAppKey, delegate: self)
    }
    
    @objc
    func initializationDidComplete() {
        ISIntegrationHelper.validateIntegration()
    }

    
    private func createStartView(window: UIWindow) {
        self.window = window
        let countryCheckScreen = rootAssembly.presentationAssembly.getCountryCheckScreen()
        window.rootViewController = countryCheckScreen
        window.makeKeyAndVisible()
    }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard
            let window = self.window,
            window.rootViewController != vc
        else {
            return
        }
        window.rootViewController = UINavigationController(rootViewController: vc)
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: nil,
                          completion: nil)
    }

    // MARK: UISceneSession Lifecycle
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge, .banner])
    }
    
    func application( _ application: UIApplication,
                      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        rootAssembly.serviceAssembly.userInfoService.saveNotificationToken(token: token)
        rootAssembly.serviceAssembly.networkService.sendPushToken(token: token)
        
        
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register: \(error)")
    }
}
