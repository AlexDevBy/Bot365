//
//  DatabaseManager.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation
import CoreData

protocol IStorageManager: AnyObject {
    func saveEvent(event: SportEvent, with context: NSManagedObjectContext, completionHandler: FinishedCompletionHandler)
    func getReminder(withPredicate: NSPredicate?, by context: NSManagedObjectContext) -> [Reminder]
    func removeReminder(context: NSManagedObjectContext, predicate: NSPredicate)
}

class DatabaseStorage: IStorageManager {
    func saveEvent(event: SportEvent, with context: NSManagedObjectContext, completionHandler: (Bool) -> ()) {
        context.performAndWait {
            _ = Reminder.insert(into: context, event: event)
        }
        _ = context.saveOrRollback()
        completionHandler(true)
    }
    
    func getReminder(withPredicate: NSPredicate?, by context: NSManagedObjectContext) -> [Reminder] {
        return Reminder.fetch(in: context, configurationBlock: { request in request.predicate = withPredicate})
    }
    
    func removeReminder(context: NSManagedObjectContext, predicate: NSPredicate) {
        guard let reminder = Reminder.fetch(in: context, configurationBlock: { request in request.predicate = predicate }).first
        else { return }
        context.delete(reminder)
        _ = context.saveOrRollback()

    }
}
