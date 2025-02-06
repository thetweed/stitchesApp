//
//  Counter.swift
//  stitchesApp
//
//  Created by Laurie on 2/5/25.
//

import Foundation
import CoreData

    class Counter: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var currentCount: Int32
    @NSManaged public var targetCount: Int32
    @NSManaged public var counterType: String // "row", "stitch", "repeat"
    @NSManaged public var notes: String?
    @NSManaged public var project: Project?
    @NSManaged public var lastModified: Date
}


extension Counter: Identifiable {
    @discardableResult
    static func create(in context: NSManagedObjectContext,
                      name: String,
                      counterType: String) -> Counter {
        let counter = Counter(context: context)
        counter.id = UUID()
        counter.name = name
        counter.counterType = counterType
        counter.currentCount = 0
        counter.lastModified = Date()
        return counter
    }
    
    static let counterTypes = ["row", "stitch", "repeat"]
}

//Set ups for later use
extension Counter {
    @NSManaged public var stitchesPerRepeat: Int32  // For repeat counters
    @NSManaged public var isActive: Bool            // To track active vs archived counters
    @NSManaged public var sequence: Int16           // To maintain order of counters in a project
}

extension Counter {
    var safeID: NSManagedObjectID {
        self.objectID
    }
}

extension Counter {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Counter> {
        let request = NSFetchRequest<Counter>(entityName: "Counter")
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Counter.lastModified, ascending: false)]
        return request
    }
}
