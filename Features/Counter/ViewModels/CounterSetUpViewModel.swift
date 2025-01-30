//
//  CounterSetUpViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//

import SwiftUI
import CoreData

@MainActor
class CounterSetupViewModel: ObservableObject {
    @Published var counterName: String = ""
    @Published var counterType: String = "stitch"
    @Published var targetCount: Int = 0
    @Published var startingCount: Int = 0
    @Published var stitchesPerRepeat: Int = 0
    @Published var notes: String = ""
    
    private let project: Project?
    
    init(project: Project? = nil) {
        self.project = project
    }
    
    var isValid: Bool {
        !counterName.isEmpty && targetCount > 0
    }
    
    /*func saveCounter(context: NSManagedObjectContext) async {
        await context.perform {
            let counter = Counter.create(in: context,
                                       name: self.counterName.isEmpty ? "Unnamed Counter" : self.counterName,
                                       counterType: self.counterType)
            
            counter.currentCount = Int32(self.startingCount)
            counter.targetCount = Int32(self.targetCount)
            counter.notes = self.notes
            
            if let project = self.project {
                project.addToCounters(counter)
                counter.project = project
            }
            
            try? context.save()
        }
    }*/
    
    func saveCounter(context: NSManagedObjectContext) async {
        await context.perform {
            let counter = Counter.create(in: context,
                                       name: self.counterName.isEmpty ? "Unnamed Counter" : self.counterName,
                                       counterType: self.counterType)
            
            counter.currentCount = Int32(self.startingCount)
            counter.targetCount = Int32(self.targetCount)
            counter.notes = self.notes
            counter.lastModified = Date()
            
            if let project = self.project {
                counter.project = project
                project.addToCounters(counter)
                project.lastModified = Date()
            }
            
            do {
                try context.save()
                print("Counter saved successfully")
            } catch {
                print("Error saving counter: \(error)")
            }
        }
    }
}

/*class CounterSetupViewModel: ObservableObject {
    @Published var counterName: String = ""
    @Published var counterType: String = "stitch"
    @Published var targetCount: Int = 0
    @Published var startingCount: Int = 0
    @Published var stitchesPerRepeat: Int = 0
    @Published var notes: String = ""
    @Published var selectedProject: Project?
    
    private let initialProject: Project?
    
    init(project: Project? = nil) {
        self.initialProject = project
        self.selectedProject = project
    }
    
    func saveCounter(context: NSManagedObjectContext) {
            context.performAndWait {
                let counter = Counter.create(in: context,
                                           name: counterName.isEmpty ? "Unnamed Counter" : counterName,
                                           counterType: counterType)
                
                counter.currentCount = Int32(startingCount)
                counter.targetCount = Int32(targetCount)
                counter.notes = notes
                
                if let project = selectedProject {
                    project.addToCounters(counter)
                    counter.project = project
                }
                
                try? context.save()
            }
        }
}
*/
