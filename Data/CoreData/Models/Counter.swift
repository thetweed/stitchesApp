//
//  Counter.swift
//  stitchesApp
//
//  Created by Laurie on 1/14/25.
//

import Foundation
import CoreData

// Counter Entity
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

extension Counter {
    // Convenience initializer
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
    
    // Counter types
    static let counterTypes = ["row", "stitch", "repeat"]
}
