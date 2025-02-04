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
    
    let project: Project?
    private let countersToAttach: Set<Counter>?
    var onCounterCreated: ((Counter) -> Void)?
    
    init(project: Project? = nil,
         countersToAttach: Set<Counter>? = nil,
         onCounterCreated: ((Counter) -> Void)? = nil) {
        self.project = project
        self.countersToAttach = countersToAttach
        self.onCounterCreated = onCounterCreated
    }
    
    var isValid: Bool {
        !counterName.isEmpty && targetCount > 0
    }
    
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
                    DispatchQueue.main.async {
                        self.onCounterCreated?(counter)
                    }
                } catch {
                    print("Error saving counter: \(error)")
                }
            }
        }
}

