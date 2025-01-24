//
//  BasicStitchCounterViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/15/25.
//
import SwiftUI
import CoreData

class StitchCounterViewModel: ObservableObject {
    @Published var currentCount: Int = 0
    @Published var targetCount: Int = 0
    private var managedObjectContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        // Load last saved count if exists
        loadLastCount()
    }
    
    // Increment count
    func count() {
        currentCount += 1
        saveCount()
    }
    
    // Decrement count (undo stitch)
    func undoStitch() {
        if currentCount > 0 {
            currentCount -= 1
            saveCount()
        }
    }
    
    // Reset count to specific number
    func resetCount(to newCount: Int = 0) {
        currentCount = newCount
        saveCount()
    }
    
    // Set target count
    func setTargetCount(_ target: Int) {
        targetCount = target
        saveCount()
    }
    
    // Save current count to CoreData
    private func saveCount() {
        let counter = Counter(context: managedObjectContext)
        counter.currentCount = Int32(currentCount)
        counter.name = "\(counter.name)"
        counter.lastModified = Date()
        counter.targetCount = Int32(targetCount)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving count: \(error)")
        }
    }
    
    // Load last saved count
    private func loadLastCount() {
        let fetchRequest = NSFetchRequest<Counter>(entityName: "Counter")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Counter.lastModified, ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            if let lastCounter = try managedObjectContext.fetch(fetchRequest).first {
                currentCount = Int(lastCounter.currentCount)
                targetCount = Int(lastCounter.targetCount)
            }
        } catch {
            print("Error loading last count: \(error)")
        }
    }
}
