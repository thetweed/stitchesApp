//
//  Yarn.swift
//  stitchesApp
//
//  Created by Laurie on 1/14/25.
//

import Foundation
import CoreData

//@objc(Yarn)
//public  .. @objc(projects) public
class Yarn: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var brand: String
    @NSManaged public var colorName: String
    @NSManaged public var colorNumber: String?
    @NSManaged public var weightCategory: String // Lace, Super Fine, Fine, Light, Medium, Bulky, Super Bulky, Jumbo
    @NSManaged public var fiberContent: String?
    @NSManaged public var totalYardage: Double
    @NSManaged public var usedYardage: Double
    @NSManaged public var purchaseDate: Date?
    @NSManaged var projects: NSSet?
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
    func addToProjects(_ project: Project) {
        let projects = self.projects?.mutableCopy() as? NSMutableSet ?? NSMutableSet()
        projects.add(project)
        self.projects = projects as NSSet
    }
    
    func removeFromProjects(_ project: Project) {
        let projects = self.projects?.mutableCopy() as? NSMutableSet ?? NSMutableSet()
        projects.remove(project)
        self.projects = projects as NSSet
    }
    
    var projectsArray: [Project] {
            let set = projects as? Set<Project> ?? []
            return Array(set).sorted { $0.name < $1.name }
        }
}

extension Yarn {
    func validateProjectRelationship(_ project: Project) -> Bool {
        projectsArray.contains(project)
    }
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


/*extension Yarn {
   @objc(addProjectsObject:)
    @NSManaged public func addToProjects(_ value: Project)
    
    @objc(removeProjectsObject:)
    @NSManaged public func removeFromProjects(_ value: Project)
    
    @objc(addProjects:)
    @NSManaged public func addToProjects(_ values: NSSet)
    
    @objc(removeProjects:)
    @NSManaged public func removeFromProjects(_ values: NSSet)
}*/
