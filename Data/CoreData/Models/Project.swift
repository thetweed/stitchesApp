//
//  Project.swift
//  stitchesApp
//
//  Created by Laurie on 1/14/25.
//

import Foundation
import CoreData

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
        print("Creating new Project entity")
        let project = Project(context: context)
        project.id = UUID()
        project.name = name
        project.projectType = projectType
        project.startDate = startDate
        project.status = "Not Started"
        project.currentRow = 0
        project.lastModified = Date()
        print("Created project with name: \(name), id: \(project.id)")
        return project
    }
}

extension Project {
    var safeID: NSManagedObjectID {
        self.objectID
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
            let projectYarns = self.yarns?.mutableCopy() as? NSMutableSet ?? NSMutableSet()
            let yarnProjects = yarn.projects?.mutableCopy() as? NSMutableSet ?? NSMutableSet()
            
            projectYarns.add(yarn)
            yarnProjects.add(self)
            
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
            let projectYarns = self.yarns?.mutableCopy() as? NSMutableSet ?? NSMutableSet()
            let yarnProjects = yarn.projects?.mutableCopy() as? NSMutableSet ?? NSMutableSet()
            
            projectYarns.remove(yarn)
            yarnProjects.remove(self)
            
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
    func debugYarnRelationship() {
        print("Current yarns set: \(String(describing: yarns))")
        print("Yarns count: \(yarns?.count ?? 0)")
        print("Yarns type: \(String(describing: type(of: yarns)))")
    }
}

extension Project {
    var countersArray: [Counter] {
        let set = counters as? Set<Counter> ?? []
        return Array(set).sorted { $0.lastModified > $1.lastModified }
    }
    
    func addToCounters(_ counter: Counter) {
        let counters = self.counters?.mutableCopy() as? NSMutableSet ?? NSMutableSet()
        counters.add(counter)
        self.counters = counters as NSSet
        self.lastModified = Date()
    }
    
    func removeFromCounters(_ counter: Counter) {
        let counters = self.counters?.mutableCopy() as? NSMutableSet ?? NSMutableSet()
        counters.remove(counter)
        self.counters = counters as NSSet
        self.lastModified = Date()
    }
}

class ProjectDateFormatter {
    static let shared = ProjectDateFormatter()
    
    private let dateFormatter: DateFormatter
    
    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
    }
    
    func string(from date: Date) -> String {
        dateFormatter.string(from: date)
    }
    
    func relativeString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

extension Project {
    func prepareForDeletion(in context: NSManagedObjectContext) {
        context.performAndWait {
            // Detach counters, delete counters
            countersArray.forEach { counter in
                removeFromCounters(counter)
                context.delete(counter)
            }
            
            // Detach yarns (don't delete yarns)
            yarnsArray.forEach { yarn in
                removeYarn(yarn, context: context)
            }
        }
    }
}

