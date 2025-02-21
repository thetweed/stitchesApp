//
//  LogEntry+CoreDataProperties.swift
//  stitchesApp
//
//  Created by Laurie on 2/3/25.
//
//

import SwiftUI
import CoreData

@objc(LogEntry)
public class LogEntry: NSManagedObject {
    
}

extension LogEntry {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LogEntry> {
        return NSFetchRequest<LogEntry>(entityName: "LogEntry")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var message: String?
    @NSManaged public var category: String?
    
}

extension LogEntry : Identifiable {
    
}

extension LogEntry {
    var safeID: NSManagedObjectID {
        self.objectID
    }
}

extension LogEntry {
    convenience init(context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.timestamp = Date()
    }
}
