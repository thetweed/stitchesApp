//
//  StitchCounterViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/28/25.
//

import SwiftUI
import CoreData

class StitchCounterViewModel: ObservableObject {
    @Published var currentCount: Int = 0
    @Published var targetCount: Int = 0
    @Published var counterName: String = ""
    @Published var notes: String = ""
    
    private var counter: Counter?
    private let context: NSManagedObjectContext
    private let project: Project?
    
    init(context: NSManagedObjectContext, project: Project? = nil, counter: Counter? = nil) {
        self.context = context
        self.project = project
        self.counter = counter
        
        if let counter = counter {
            // Load existing counter
            currentCount = Int(counter.currentCount)
            targetCount = Int(counter.targetCount)
            counterName = counter.name
            notes = counter.notes ?? ""
        }
    }
    
    func count() {
        currentCount += 1
        saveCount()
    }
    
    func undoStitch() {
        if currentCount > 0 {
            currentCount -= 1
            saveCount()
        }
    }
    
    func resetCount(to newCount: Int = 0) {
        currentCount = newCount
        saveCount()
    }
    
    func setTargetCount(_ target: Int) {
        targetCount = target
        saveCount()
    }
    
    
    private func saveCount() {
        context.performAndWait {
            if counter == nil {
                counter = Counter(context: context)
                counter?.id = UUID()
                counter?.name = counterName.isEmpty ? "Main Counter" : counterName
                counter?.project = project
            }
            
            counter?.currentCount = Int32(currentCount)
            counter?.targetCount = Int32(targetCount)
            counter?.notes = notes
            counter?.lastModified = Date()
            
            do {
                try context.save()
            } catch {
                print("Error saving count: \(error)")
            }
        }
    }
}
