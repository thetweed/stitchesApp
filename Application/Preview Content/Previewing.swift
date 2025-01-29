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

extension PreviewingData {
    var sampleProjectWithCounter: (NSManagedObjectContext) -> Project { { context in
        let project = Project.create(
            in: context,
            name: "Sample Knitting Project",
            projectType: "Knitting"
        )

        let counter = Counter.create(
            in: context,
            name: "Sleeve Increases",
            counterType: "row"
        )
        counter.currentCount = 0
        counter.targetCount = 20
        counter.notes = "Increase 1 stitch at beginning and end of every RS row"
        counter.project = project
        
        try? context.save()
        return project
    }}
}

extension PreviewingData {
    struct SampleCounters {
        let inProgress: Counter
        let completed: Counter
        let empty: Counter
        let row: Counter
        let stitch: Counter
        let `repeat`: Counter
        let withNotes: Counter
    }
    
    var sampleCounters: (NSManagedObjectContext) -> SampleCounters { { context in
        // Clear existing counters
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Counter.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try? context.execute(batchDeleteRequest)
        context.reset()
        
        // Create sample counters
        let inProgress = Counter.create(in: context, name: "Sleeve Increases", counterType: "stitch")
        inProgress.currentCount = 15
        inProgress.targetCount = 30
        
        let completed = Counter.create(in: context, name: "Collar Decreases", counterType: "stitch")
        completed.currentCount = 20
        completed.targetCount = 20
        
        let empty = Counter.create(in: context, name: "New Counter", counterType: "stitch")
        empty.currentCount = 0
        empty.targetCount = 10
        
        let row = Counter.create(in: context, name: "Body Rows", counterType: "row")
        row.currentCount = 5
        row.targetCount = 15
        
        let stitch = Counter.create(in: context, name: "Increases", counterType: "stitch")
        stitch.currentCount = 8
        stitch.targetCount = 16
        
        let repeatCounter = Counter.create(in: context, name: "Cable Pattern", counterType: "repeat")
        repeatCounter.currentCount = 3
        repeatCounter.targetCount = 6
        
        let withNotes = Counter.create(in: context, name: "Pattern Section", counterType: "row")
        withNotes.currentCount = 10
        withNotes.targetCount = 20
        withNotes.notes = "Increase 1 stitch at beginning and end of every RS row"
        
        try? context.save()
        
        return SampleCounters(
            inProgress: inProgress,
            completed: completed,
            empty: empty,
            row: row,
            stitch: stitch,
            repeat: repeatCounter,
            withNotes: withNotes
        )
    }}
}

extension PreviewingData {
    var sampleCountersWithProjects: (NSManagedObjectContext) -> Void { { context in
        // Clear existing data
        let counterRequest: NSFetchRequest<NSFetchRequestResult> = Counter.fetchRequest()
        let projectRequest: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        try? context.execute(NSBatchDeleteRequest(fetchRequest: counterRequest))
        try? context.execute(NSBatchDeleteRequest(fetchRequest: projectRequest))
        context.reset()
        
        // Create some sample projects
        let sweater = Project.create(in: context, name: "Summer Sweater", projectType: "Knitting")
        let socks = Project.create(in: context, name: "Striped Socks", projectType: "Knitting")
        
        // Create counters and associate with projects
        let sleeves = Counter.create(in: context, name: "Sleeve Increases", counterType: "row")
        sleeves.currentCount = 15
        sleeves.targetCount = 30
        sleeves.project = sweater
        
        let body = Counter.create(in: context, name: "Body Length", counterType: "row")
        body.currentCount = 45
        body.targetCount = 120
        body.project = sweater
        
        let heelTurns = Counter.create(in: context, name: "Heel Turns", counterType: "stitch")
        heelTurns.currentCount = 8
        heelTurns.targetCount = 16
        heelTurns.project = socks
        
        let stripePattern = Counter.create(in: context, name: "Stripe Pattern", counterType: "repeat")
        stripePattern.currentCount = 3
        stripePattern.targetCount = 6
        stripePattern.project = socks
        stripePattern.notes = "Change color every 4 rows"
        
        // Create a counter without a project
        let standalone = Counter.create(in: context, name: "Gauge Swatch", counterType: "stitch")
        standalone.currentCount = 0
        standalone.targetCount = 40
        
        try? context.save()
    }}
}
