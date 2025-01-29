//
//  Previewing.swift
//  stitchesApp
//
//  Created by Laurie on 1/24/25.
//

import SwiftUI
import CoreData

struct Previewing<Content: View, Model>: View {
    var content: Content
    var persistence: CoreDataManager
    
    init(_ keyPath: KeyPath<PreviewingData, (NSManagedObjectContext) -> Model>, @ViewBuilder content: @escaping (Model) -> Content) {
        self.persistence = .shared
        let context = persistence.container.viewContext
        let data = PreviewingData()
        let closure = data[keyPath: keyPath]
        let models = closure(context)
        self.content = content(models)
    }
    
    var body: some View {
        content
            .environment(\.managedObjectContext, persistence.container.viewContext)
    }
}

struct PreviewingData {
    
    var sampleProjects: (NSManagedObjectContext) -> [Project] { { context in
         let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
         let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
         do {
             try context.execute(batchDeleteRequest)
             context.reset() // Reset context after batch delete
         } catch {
             print("Failed to clear projects: \(error)")
         }
           
           var sampleProjects = [Project]()
           for _ in 0..<4 {
               let project = Project.create(
                   in: context,
                   name: "Project \(sampleProjects.count + 1)",
                   projectType: "Knitting"
               )
               project.patternNotes = "This is a sample pattern note"
               project.currentRow = 100
               sampleProjects.append(project)
               project.status = "Not Started"
           }
           try? context.save()
           return sampleProjects
       }}

    var sampleYarns: (NSManagedObjectContext) -> [Yarn] { { context in
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Yarn.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            context.reset() // Reset context after batch delete
        } catch {
            print("Failed to clear yarns: \(error)")
        }
        
        var sampleYarns = [Yarn]()
           for i in 0..<5 {
               let yarn = Yarn.create(
                   in: context,
                   brand: "Brand \(i + 1)",
                   colorName: "Color \(i + 1)",
                   weightCategory: Yarn.weightCategories[i % Yarn.weightCategories.count],
                   fiberContent: "Wool/Acrylic Blend",
                   totalYardage: 100.0
               )
               yarn.colorNumber = "\(i + 1)"
               yarn.purchaseDate = Date()
               sampleYarns.append(yarn)
           }
           try? context.save()
           return sampleYarns
        }}
    
    var sampleProjectWithYarns: (NSManagedObjectContext) -> Project { { context in
        let project = Project.create(
            in: context,
            name: "Preview Project",
            projectType: "Knitting"
        )
        
        let yarn = Yarn.create(
            in: context,
            brand: "Preview Yarn",
            colorName: "Natural",
            weightCategory: "Worsted",
            fiberContent: "100% Wool",
            totalYardage: 220
        )

        context.performAndWait {
            project.addYarn(yarn, context: context)
            
            do {
                try context.save()
            } catch {
                print("Preview context save error: \(error)")
            }
        }
        
        return project
    }}
    
    var sampleCounter: (NSManagedObjectContext) -> Counter { { context in
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Counter.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            context.reset() // Reset context after batch delete
        } catch {
            print("Failed to clear counters: \(error)")
        }
        
        let counter = Counter(context: context)
        counter.currentCount = 42
        counter.targetCount = 100
        counter.id = UUID()
        
        try? context.save()
        return counter
    }}
}

/*struct PreviewingData {
    
    var sampleYarns: (NSManagedObjectContext) -> [Yarn] { { context in
        clearEntityData(of: Yarn.self, in: context)
        
        var sampleYarns = [Yarn]()
        for i in 1...9 {
            let yarn = Yarn.create(
                in: context,
                brand: "Brand \(i)",
                colorName: "Color \(i)",
                weightCategory: Yarn.weightCategories[i % Yarn.weightCategories.count],
                fiberContent: "Wool/Acrylic Blend",
                totalYardage: Double(i * 100)
            )
            yarn.colorNumber = String(format: "%04d", i)
            yarn.purchaseDate = Calendar.current.date(byAdding: .day, value: -i, to: Date())
            yarn.usedYardage = Double(i * 10)
            sampleYarns.append(yarn)
        }
        
        try? context.save()
        return sampleYarns
    }}
    
    private func clearEntityData<T: NSManagedObject>(of type: T.Type, in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            let result = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
            let changes: [AnyHashable: Any] = [
                NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []
            ]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
        } catch {
            print("Failed to clear \(String(describing: T.self)) data: \(error)")
        }
    }
}

extension PreviewingData {
    var sampleProjectWithYarns: (NSManagedObjectContext) -> Project { { context in
        // First clear existing data
        clearEntityData(of: Project.self, in: context)
        clearEntityData(of: Yarn.self, in: context)
        
        // Create yarns first
        let yarns = self.sampleYarns(context)
        
        // Create project with explicit relationship setup
        let project = Project.create(
            in: context,
            name: "Complex Sample Project",
            projectType: "Knitting"
        )
        
        project.patternNotes = """
        Sample Pattern
        
        Materials:
        - Main Color: Brand 1 Color 1 (3 skeins)
        - Contrast Color: Brand 2 Color 2 (1 skein)
        
        Gauge:
        22 sts x 28 rows = 4" in stockinette
        
        Instructions:
        CO 200 sts
        Row 1: *K2, P2* repeat to end
        Row 2: Work as sts appear
        
        Continue in pattern until piece measures 20"
        """
        project.currentRow = 42
        project.status = "In Progress"
        
        // Set up bidirectional relationships
        context.performAndWait {
            yarns.prefix(3).forEach { yarn in
                // Use the relationship management methods we defined
                project.addYarn(yarn, context: context)
                
                // Debug verification
                print("Added yarn \(yarn.brand) to project")
                print("Yarn projects count: \(yarn.projects?.count ?? 0)")
                print("Project yarns count: \(project.yarns?.count ?? 0)")
            }
            
            // Verify relationships
            if let projectYarns = project.yarns {
                print("Project has \(projectYarns.count) yarns after setup")
            }
            
            // Save context
            do {
                try context.save()
            } catch {
                print("Error saving context in preview: \(error)")
            }
        }
        
        return project
    }}
    
    // Modify your sampleProjects to also include yarn relationships
    var sampleProjects: (NSManagedObjectContext) -> [Project] { { context in
        clearEntityData(of: Project.self, in: context)
        clearEntityData(of: Yarn.self, in: context)
        
        // Create yarns first
        let yarns = self.sampleYarns(context)
        var sampleProjects = [Project]()
        
        context.performAndWait {
            for i in 1...4 {
                let project = Project.create(
                    in: context,
                    name: "Sample Project \(i)",
                    projectType: "Knitting"
                )
                project.patternNotes = """
                    Sample pattern notes for project \(i)
                    Needle size: US 7
                    Gauge: 20 sts = 4"
                    """
                project.currentRow = Int32(i * 10)
                project.status = "In Progress"
                
                // Add some yarns to each project
                yarns.prefix(2).forEach { yarn in
                    project.addYarn(yarn, context: context)
                }
                
                sampleProjects.append(project)
            }
            
            // Save context
            do {
                try context.save()
            } catch {
                print("Error saving context in preview: \(error)")
            }
        }
        
        return sampleProjects
    }}
}*/

/*var sampleProjects: (NSManagedObjectContext) -> [Project] { { context in
    clearEntityData(of: Project.self, in: context)
    var sampleProjects = [Project]()
    for i in 1...4 {
        let project = Project.create(
            in: context,
            name: "Sample Project \(i)",
            projectType: "Knitting"
        )
        project.patternNotes = """
            Sample pattern notes for project \(i)
            Needle size: US 7
            Gauge: 20 sts = 4"
            """
        project.currentRow = Int32(i * 10)
        project.status = "In Progress"
        sampleProjects.append(project)
    }
    
    try? context.save()
    return sampleProjects
}}*/

/*extension PreviewingData {
    var sampleProjectWithYarns: (NSManagedObjectContext) -> Project { { context in
        let yarns = self.sampleYarns(context)
        
        let project = Project.create(
            in: context,
            name: "Complex Sample Project",
            projectType: "Knitting"
        )

        project.patternNotes = """
        Sample Pattern
        
        Materials:
        - Main Color: Brand 1 Color 1 (3 skeins)
        - Contrast Color: Brand 2 Color 2 (1 skein)
        
        Gauge:
        22 sts x 28 rows = 4" in stockinette
        
        Instructions:
        CO 200 sts
        Row 1: *K2, P2* repeat to end
        Row 2: Work as sts appear
        
        Continue in pattern until piece measures 20"
        """
        project.currentRow = 42
        project.status = "In Progress"
        
        yarns.prefix(3).forEach { yarn in
            project.addYarn(yarn, context: context)
        }
        
        try? context.save()
        return project
    }}
}

struct PreviewContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .environment(\.managedObjectContext, CoreDataManager.shared.container.viewContext)
    }
}*/

/*struct Previewing<Content: View, Model>: View {
    var content: Content
    var persistence: CoreDataManager
    
    init(_ keyPath: KeyPath<PreviewingData, (NSManagedObjectContext) -> Model>, @ViewBuilder content: @escaping (Model) -> Content) {
        self.persistence = .shared
        let data = PreviewingData()
        let closure = data[keyPath: keyPath]
        let models = closure(persistence.container.viewContext)
        self.content = content(models)
    }
    
    var body: some View {
        content
            .environment(\.managedObjectContext, persistence.container.viewContext)
    }
}

struct PreviewingData {
    var sampleProjects: (NSManagedObjectContext) -> [Project] { { context in
         let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
         let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
         do {
             try context.execute(batchDeleteRequest)
             context.reset() // Reset context after batch delete
         } catch {
             print("Failed to clear projects: \(error)")
         }
           
           var sampleProjects = [Project]()
           for _ in 0..<4 {
               let project = Project.create(
                   in: context,
                   name: "Project \(sampleProjects.count + 1)",
                   projectType: "Knitting"
               )
               project.patternNotes = "This is a sample pattern note"
               project.currentRow = 100
               sampleProjects.append(project)
           }
           try? context.save()
           return sampleProjects
       }}

    var sampleYarns: (NSManagedObjectContext) -> [Yarn] { { context in
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Yarn.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            context.reset() // Reset context after batch delete
        } catch {
            print("Failed to clear yarns: \(error)")
        }
        
        var sampleYarns = [Yarn]()
           for i in 0..<9 {
               let yarn = Yarn.create(
                   in: context,
                   brand: "Brand \(i + 1)",
                   colorName: "Color \(i + 1)",
                   weightCategory: Yarn.weightCategories[i % Yarn.weightCategories.count],
                   fiberContent: "Wool/Acrylic Blend",
                   totalYardage: 100.0
               )
               yarn.colorNumber = "\(i + 1)"
               yarn.purchaseDate = Date()
               sampleYarns.append(yarn)
           }
           try? context.save()
           return sampleYarns
        }}
}

extension PreviewingData {
    var sampleProjectWithYarns: (NSManagedObjectContext) -> Project { { context in
        let yarns = self.sampleYarns(context)

        let project = Project.create(
            in: context,
            name: "Sample Sweater",
            projectType: "Knitting"
        )
        project.patternNotes = """
            Needle size: US 7 (4.5mm)
            Gauge: 20 sts x 28 rows = 4" in stockinette
            
            Pattern Instructions:
            CO 200 sts
            Row 1: *K2, P2* repeat to end
            Row 2: Work as sts appear
        """
        project.currentRow = 42
        project.status = "In Progress"

        project.yarns = NSSet(array: Array(yarns.prefix(3))) as? Set<Yarn>
        
        try? context.save()
        return project
    }}
}
*/
