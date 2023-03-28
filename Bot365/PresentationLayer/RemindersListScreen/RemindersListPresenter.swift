//
//  CalendarPresenter.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation
import NotificationCenter

protocol ICalendarPresenter: AnyObject {
    func getMyStaidums()
    func attachView(_ view: ICalendarView)
    func removeEvent(with id: String)
}

protocol ICalendarView: AnyObject {
    func setEvents(events: [SportEvent])
}

class RemindersListPresenter: ICalendarPresenter {
    
    private weak var view: ICalendarView?
    private let databaseService: IDatabaseService
    private var eventsSource: [SportEvent] = []
    
    init(databaseService: IDatabaseService) {
        self.databaseService = databaseService
    }

    func attachView(_ view: ICalendarView) {
        self.view = view
    }

    func getMyStaidums() {
        eventsSource = databaseService.getReminders(with: NSPredicate(format: "time > %@", NSDate()))
        print("eventsSource.count:\(eventsSource.count)")
        view?.setEvents(events: eventsSource)
    }
    
    func removeEvent(with id: String) {
        guard
            let eventIndex = eventsSource.firstIndex(where: {$0.identifier == id}),
            let event = eventsSource[safe: eventIndex]
        else { return }
        eventsSource.remove(at: eventIndex)
        view?.setEvents(events: eventsSource)
        databaseService.delete(event: event) { _ in
            let center = UNUserNotificationCenter.current()
            center.removeDeliveredNotifications(withIdentifiers: [event.identifier])
            center.removePendingNotificationRequests(withIdentifiers: [event.identifier])
        }
    }
}
