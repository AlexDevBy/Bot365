//
//  DatabaseService.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation
import CoreData

typealias FinishedCompletionHandler = (Bool) -> ()

protocol IDatabaseService {
    func saveReminder(event: SportEvent, completionHandler: FinishedCompletionHandler)
    func getReminders(with predicate: NSPredicate?) -> [SportEvent]
    func delete(event: SportEvent, completionHandler: FinishedCompletionHandler)
}

class DatabaseService: IDatabaseService {
    func saveReminder(event: SportEvent, completionHandler: (Bool) -> ()) {
        db.saveEvent(event: event, with: CDStack.mainContext, completionHandler: completionHandler)
    }
    
    func getReminders(with predicate: NSPredicate?) -> [SportEvent] {
        db.getReminder(withPredicate: predicate, by: CDStack.mainContext).map({
            SportEvent(identifier: $0.identifier, date: $0.time, sportObject: SportObject(type: SportType(rawValue: $0.sportType)!,
                                                                                          name: $0.stadionName,
                                                                                          address: $0.stadionAddress))
        })
    }
    
    func delete(event: SportEvent, completionHandler: (Bool) -> ()) {
        db.removeReminder(context: CDStack.mainContext, predicate: NSPredicate(format: "identifier == %@", event.identifier))
    }
    
    private let db: IStorageManager
    private let CDStack: ICoreDataStack
    
    init(db: IStorageManager, coreDataStack: ICoreDataStack) {
        self.db = db
        self.CDStack = coreDataStack
    }
}
