//
//  Yarn.swift
//  stitchesApp
//
//  Created by Laurie on 1/14/25.
//

import Foundation
import CoreData

class Yarn: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var brand: String
    @NSManaged public var colorName: String
    @NSManaged public var colorNumber: String?
    @NSManaged public var weightCategory: String // Lace, Super Fine, Fine, Light, Medium, Bulky, Super Bulky, Jumbo
    @NSManaged public var fiberContent: String?
    @NSManaged public var totalYardage: Double
    @NSManaged public var usedYardage: Double
    @NSManaged public var purchaseDate: Date?
    @NSManaged public var projects: Set<Project>?
    @NSManaged public var photoData: Data?
}

extension Yarn {
    @discardableResult
    static func create(in context: NSManagedObjectContext,
                      brand: String,
                      colorName: String,
                      weightCategory: String,
                      fiberContent: String,
                      totalYardage: Double) -> Yarn {
        let yarn = Yarn(context: context)
        yarn.id = UUID()
        yarn.brand = brand
        yarn.colorName = colorName
        yarn.weightCategory = weightCategory
        yarn.fiberContent = fiberContent
        yarn.totalYardage = totalYardage
        yarn.usedYardage = 0
        return yarn
    }
    
    static let weightCategories = [
        "Lace", "Super Fine", "Fine", "Light", "Medium",
        "Bulky", "Super Bulky", "Jumbo"
    ]
    
    var remainingYardage: Double {
        return totalYardage - usedYardage
    }
}

extension Yarn {
    @objc(addProjectsObject:)
    @NSManaged public func addToProjects(_ value: Project)
    
    @objc(removeProjectsObject:)
    @NSManaged public func removeFromProjects(_ value: Project)
}

extension Yarn {
    @objc var yarnID: UUID {
        get {
            id
        }
        set {
            id = newValue
        }
    }
}

extension Yarn {
    var safeID: NSManagedObjectID {
        self.objectID
    }
}
