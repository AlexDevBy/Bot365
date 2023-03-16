//
//  LocationPresenter.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 23.11.2022.
//

import UIKit
import UserNotifications

protocol ILocationPresenter: AnyObject {
    var choosenDate: Date? { get }
    var sportObject: SportObject { get }
    func createReminder()
    func attachView(view: ILocationView)
    func setDate(_ date: Date)
    func getCategories() -> [CategoriesModels]
    func setHoursAndMinutes(hours: Int, minuts: Int)
}

protocol ILocationView: AnyObject {
    func allowToSave()
    func showSavedNotificationState()
    func showMessage(error: String)
}

class CreateReminderPresenter: ILocationPresenter {
    
    weak var view: ILocationView?
    var choosenDate: Date?
    private let notificationCenter = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    private var allComponentsWasSet: Bool = false
    private let databaseService: IDatabaseService
    let _sportObject: SportObject
    var sportObject: SportObject {
        return _sportObject
    }
    
    init(
        databaseService: IDatabaseService,
        sportObject: SportObject
    ) {
        self.databaseService = databaseService
        self._sportObject = sportObject
    }
    func attachView(view: ILocationView) {
        self.view = view
    }
    
    func setDate(_ date: Date) {
        self.choosenDate = date
    }
    
    func setHoursAndMinutes(hours: Int, minuts: Int) {
        guard let date = choosenDate else { return }
        let calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .minute, .year, .day, .month], from: date)
        components.hour = hours
        components.minute = minuts
        choosenDate = calendar.date(from: components)
        if !allComponentsWasSet {
            allComponentsWasSet = true
            view?.allowToSave()
        }
    }
    
    func getCategories() -> [CategoriesModels] {
        return sportObject.type.availableFor.map { CategoriesModels(type: $0) }
    }
    
    func createReminder() {
        askNotificationsPermissions()
    }
    
    private func askNotificationsPermissions() {
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                guard
                    let bundleId = Bundle.main.bundleIdentifier,
                    let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
                else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                self.scheduleNotification()
            }
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent() // Содержимое уведомления
        content.title = "Don't forget"
        content.body = "You are scheduled visit to \(sportObject.name)"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        guard let date = choosenDate else { return }
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let identifier = date.toString() + sportObject.type.rawValue
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        notificationCenter.add(request) { [weak self] (error) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    self?.view?.showMessage(error: error.localizedDescription)
                } else {
                    self?.databaseService.saveReminder(event: SportEvent(identifier: identifier,
                                                                         date: date,
                                                                         sportObject: SportObject(type: strongSelf.sportObject.type,
                                                                                                  name: strongSelf.sportObject.name,
                                                                                                  address: strongSelf.sportObject.address)),
                                                       completionHandler: { _ in
                        self?.view?.showSavedNotificationState()
                    })
                }
            }
        }
    }
}
