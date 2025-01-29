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
