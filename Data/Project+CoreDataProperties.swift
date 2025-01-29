//
//  Project+CoreDataProperties.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var currentRow: Int32
    @NSManaged public var deleted: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var lastModified: Date?
    @NSManaged public var name: String?
    @NSManaged public var patternNotes: String?
    @NSManaged public var photoData: Data?
    @NSManaged public var projectType: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var status: String?
    @NSManaged public var counters: NSSet?
    @NSManaged public var yarns: NSSet?
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for counters
extension Project {

    @objc(addCountersObject:)
    @NSManaged public func addToCounters(_ value: Counter)

    @objc(removeCountersObject:)
    @NSManaged public func removeFromCounters(_ value: Counter)

    @objc(addCounters:)
    @NSManaged public func addToCounters(_ values: NSSet)

    @objc(removeCounters:)
    @NSManaged public func removeFromCounters(_ values: NSSet)

}

// MARK: Generated accessors for yarns
extension Project {

    @objc(addYarnsObject:)
    @NSManaged public func addToYarns(_ value: Yarn)

    @objc(removeYarnsObject:)
    @NSManaged public func removeFromYarns(_ value: Yarn)

    @objc(addYarns:)
    @NSManaged public func addToYarns(_ values: NSSet)

    @objc(removeYarns:)
    @NSManaged public func removeFromYarns(_ values: NSSet)

}

// MARK: Generated accessors for photos
extension Project {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

extension Project : Identifiable {

}
