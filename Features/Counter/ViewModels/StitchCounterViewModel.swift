//
//  StitchCounterViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/28/25.
//

import SwiftUI
import CoreData

class StitchCounterViewModel: ObservableObject {
    @Published private(set) var currentCount: Int = 0
    @Published var targetCount: Int = 0 {
        didSet {
            if targetCount < 0 {
                targetCount = 0
            }
            saveCount()
        }
    }
    @Published var counterName: String = "" {
        didSet {
            saveCount()
        }
    }
    @Published var notes: String = "" {
        didSet {
            saveCount()
        }
    }
    
    private var counter: Counter?
    private let context: NSManagedObjectContext
    private let project: Project?
    var progressValue: Double {
        min(Double(currentCount), Double(targetCount))
    }
    
    init(context: NSManagedObjectContext, project: Project? = nil, counter: Counter? = nil) {
        self.context = context
        self.project = project
        self.counter = counter
        
        if let counter = counter {
            currentCount = Int(counter.currentCount)
            targetCount = Int(counter.targetCount)
            counterName = counter.name
            notes = counter.notes ?? ""
        }
    }
    
    @MainActor
    func count() {
        currentCount += 1
        saveCount()
    }
    
    @MainActor
    func undoStitch() {
        guard currentCount > 0 else { return }
        currentCount -= 1
        saveCount()
    }
    
    @MainActor
    func resetCount(to newCount: Int = 0) {
        currentCount = max(0, newCount)
        saveCount()
    }
    
    private func saveCount() {
        Task {
            await context.perform {
                if self.counter == nil {
                    self.counter = Counter(context: self.context)
                    self.counter?.id = UUID()
                    self.counter?.name = self.counterName.isEmpty ? "Main Counter" : self.counterName
                    self.counter?.project = self.project
                }
                
                self.counter?.currentCount = Int32(self.currentCount)
                self.counter?.targetCount = Int32(self.targetCount)
                self.counter?.notes = self.notes
                self.counter?.lastModified = Date()
                
                do {
                    try self.context.save()
                } catch {
                    print("Error saving count: \(error)")
                }
            }
        }
    }
}

/*class StitchCounterViewModel: ObservableObject {
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
    
    
    func saveCount() {
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
*/
