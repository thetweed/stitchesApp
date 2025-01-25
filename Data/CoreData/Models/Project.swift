//
//  Project.swift
//  stitchesApp
//
//  Created by Laurie on 1/14/25.
//

import Foundation
import CoreData
// Project Entity
class Project: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var projectType: String // "knitting" or "crochet"
    @NSManaged public var startDate: Date
    @NSManaged public var status: String // "active", "completed", "paused for now"
    @NSManaged public var patternNotes: String?
    @NSManaged public var currentRow: Int32
    @NSManaged public var photoData: Data?
    @NSManaged public var lastModified: Date
    @NSManaged public var yarns: Set<Yarn>?
    @NSManaged public var counters: Set<Counter>?
 }

extension Project {
    @discardableResult
    static func create(in context: NSManagedObjectContext,
                       name: String,
                       projectType: String,
                       startDate: Date = Date()) -> Project {
        let project = Project(context: context)
        project.id = UUID()
        project.name = name
        project.projectType = projectType
        project.startDate = startDate
        project.status = "active"
        project.currentRow = 0
        project.lastModified = Date()
        return project
    }
}

extension Project {
    var safeID: NSManagedObjectID {
        self.objectID
    }
}

extension Project {
    @objc(addYarnsObject:)
    @NSManaged public func addToYarns(_ value: Yarn)
    
    @objc(removeYarnsObject:)
    @NSManaged public func removeFromYarns(_ value: Yarn)
}

extension Project {
    @objc var projectID: UUID {
        get {
            id
        }
        set {
            id = newValue
        }
    }
}

// Project status types
//static let statusTypes = ["active", "completed", "paused for now"]

// Project types
//static let projectTypes = ["knitting", "crochet"]
