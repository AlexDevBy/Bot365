//
//  ReminderDB.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation
import CoreData

@objc(Reminder)
public final class Reminder: NSManagedObject {
    
    @NSManaged public private(set) var identifier: String
    @NSManaged public private(set) var stadionAddress: String
    @NSManaged public private(set) var stadionName: String
    @NSManaged public private(set) var sportType: String
    @NSManaged public private(set) var time: Date
    
    static func insert(into context: NSManagedObjectContext, event: SportEvent) -> Reminder {
        
        func setupPersonDBModel(reminder: Reminder, with event: SportEvent) {
            reminder.identifier = event.identifier
            reminder.time = event.date
            reminder.stadionName = event.sportObject.name
            reminder.stadionAddress = event.sportObject.address
            reminder.sportType = event.sportObject.type.rawValue
        }
        
        guard let reminder = Reminder.findOrFetch(in: context, matching: NSPredicate(format: "identifier == %@", event.identifier)) else {
            let reminder: Reminder = context.insertObject()
            setupPersonDBModel(reminder: reminder, with: event)
            return reminder
        }
        setupPersonDBModel(reminder: reminder, with: event)
        return reminder
    }
    
}

extension Reminder: ManagedObjectType {
    static var entityName: String {
        "Reminder"
    }
    
    static var bySurnameSortDescriptor: [NSSortDescriptor] = [
        NSSortDescriptor(key: "time", ascending: true)
    ]
}
