//
//  CoreDataProtocols.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation
import CoreData

protocol ManagedObjectType: AnyObject, NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension ManagedObjectType {
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    public static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}
