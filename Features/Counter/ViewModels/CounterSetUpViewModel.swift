//
//  CounterSetUpViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//

import SwiftUI
import CoreData

class CounterSetupViewModel: ObservableObject {
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


/*func saveCounter(context: NSManagedObjectContext) {
    context.performAndWait {
        let counter = Counter.create(in: context,
                                   name: counterName.isEmpty ? "Unnamed Counter" : counterName,
                                   counterType: counterType)
        
        counter.currentCount = Int32(startingCount)
        counter.targetCount = Int32(targetCount)
        counter.notes = notes
        counter.project = selectedProject
        counter.lastModified = Date()
        
        if let project = selectedProject {
            project.addToCounters(counter)
        }
        
        do {
            try context.save()
            print("Counter saved successfully: \(counter.name), ID: \(counter.objectID)")
        } catch {
            print("Error saving counter: \(error)")
        }
    }
}*/

/*class CounterSetupViewModel: ObservableObject {
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
    
    func saveCounter(context: NSManagedObjectContext) {
            context.performAndWait {
                let counter = Counter.create(in: context,
                                           name: counterName.isEmpty ? "Unnamed Counter" : counterName,
                                           counterType: counterType)
                
                counter.currentCount = Int32(startingCount)
                counter.targetCount = Int32(targetCount)
                counter.notes = notes
                counter.project = project
                
                if let project = project {
                    project.addToCounters(counter)
                }
                
                do {
                    try context.save()
                } catch {
                    print("Error saving counter: \(error)")
                }
            }
        }
}
*/
