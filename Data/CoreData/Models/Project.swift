//
//  Project.swift
//  stitchesApp
//
//  Created by Laurie on 1/14/25.
//

import Foundation
import CoreData

//@objc(Project)
//public .. @objc(yarns) public
class Project: NSManagedObject, Identifiable {
    
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var projectType: String // "knitting" or "crochet"
    @NSManaged public var startDate: Date
    @NSManaged public var status: String // "Not Started, In Progress, Completed, Frogged"
    @NSManaged public var patternNotes: String?
    @NSManaged public var currentRow: Int32
    @NSManaged public var photoData: Data?
    @NSManaged public var lastModified: Date
    @objc @NSManaged var yarns: NSSet?
    @objc @NSManaged public var counters: NSSet?
    
    let statuses = ["Not Started", "In Progress", "Completed", "Frogged"]
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
    var yarnsArray: [Yarn] {
        let set = yarns as? Set<Yarn> ?? []
        return Array(set).sorted { $0.brand < $1.brand }
    }
    
   func addToYarns(_ yarn: Yarn) {
        let yarns = self.yarns?.mutableCopy() as? NSMutableSet ?? NSMutableSet()
        yarns.add(yarn)
        self.yarns = yarns as NSSet
    }
    
    func removeFromYarns(_ yarn: Yarn) {
        let yarns = self.yarns?.mutableCopy() as? NSMutableSet ?? NSMutableSet()
        yarns.remove(yarn)
        self.yarns = yarns as NSSet
    }
}

extension Project {
    func addYarn(_ yarn: Yarn, context: NSManagedObjectContext) {
        context.performAndWait {
            // Create mutable copies of both sets
            let projectYarns = self.yarns?.mutableCopy() as? NSMutableSet ?? NSMutableSet()
            let yarnProjects = yarn.projects?.mutableCopy() as? NSMutableSet ?? NSMutableSet()
            
            // Add the objects to their respective sets
            projectYarns.add(yarn)
            yarnProjects.add(self)
            
            // Update both sides of the relationship
            self.yarns = projectYarns as NSSet
            yarn.projects = yarnProjects as NSSet
            
            do {
                try context.save()
            } catch {
                print("Error saving context after adding yarn: \(error)")
            }
        }
    }
    
    func removeYarn(_ yarn: Yarn, context: NSManagedObjectContext) {
        context.performAndWait {
            // Create mutable copies of both sets
            let projectYarns = self.yarns?.mutableCopy() as? NSMutableSet ?? NSMutableSet()
            let yarnProjects = yarn.projects?.mutableCopy() as? NSMutableSet ?? NSMutableSet()
            
            // Remove the objects from their respective sets
            projectYarns.remove(yarn)
            yarnProjects.remove(self)
            
            // Update both sides of the relationship
            self.yarns = projectYarns as NSSet
            yarn.projects = yarnProjects as NSSet
            
            do {
                try context.save()
            } catch {
                print("Error saving context after removing yarn: \(error)")
            }
        }
    }
}

extension Project {
    func validateYarnRelationship(_ yarn: Yarn) -> Bool {
        yarnsArray.contains(yarn)
    }
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

extension Project {
    func debugYarnRelationship() {
        print("Current yarns set: \(String(describing: yarns))")
        print("Yarns count: \(yarns?.count ?? 0)")
        print("Yarns type: \(String(describing: type(of: yarns)))")
    }
}



/*extension Project {
    func addYarn(_ yarn: Yarn, context: NSManagedObjectContext) {
        context.performAndWait {
            addToYarns(yarn)
            yarn.addToProjects(self)
            
            do {
                try context.save()
            } catch {
                print("Error saving context after adding yarn: \(error)")
            }
        }
    }
    
    func removeYarn(_ yarn: Yarn, context: NSManagedObjectContext) {
        context.performAndWait {
            removeFromYarns(yarn)
            yarn.removeFromProjects(self)
            
            do {
                try context.save()
            } catch {
                print("Error saving context after removing yarn: \(error)")
            }
        }
    }
}*/

/*extension Project {
    @objc(addYarnsObject:)
    @NSManaged public func addToYarns(_ value: Yarn)
    
    @objc(removeYarnsObject:)
    @NSManaged public func removeFromYarns(_ value: Yarn)
    
    @objc(addYarns:)
    @NSManaged public func addToYarns(_ values: NSSet)
    
    @objc(removeYarns:)
    @NSManaged public func removeFromYarns(_ values: NSSet)
}*/
