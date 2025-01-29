//
//  BasicStitchCounterViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/15/25.
//
import SwiftUI
import CoreData

/*class BasicStitchCounterViewModel: ObservableObject {
   @Published var currentCount: Int = 0
   @Published var targetCount: Int = 0
   private var counter: Counter?
   private let context: NSManagedObjectContext
   
   init(context: NSManagedObjectContext, counter: Counter? = nil) {
       self.context = context
       self.counter = counter
       
       if let counter = counter {
           // Load existing counter
           currentCount = Int(counter.currentCount)
           targetCount = Int(counter.targetCount)
       } else {
           // Create new counter
           loadOrCreateCounter()
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
               counter?.name = "Main Counter" // Default name
           }
           
           counter?.currentCount = Int32(currentCount)
           counter?.targetCount = Int32(targetCount)
           counter?.lastModified = Date()
           
           do {
               try context.save()
           } catch {
               print("Error saving count: \(error)")
           }
       }
   }
   
   private func loadOrCreateCounter() {
       let fetchRequest = Counter.fetchRequest()
       fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Counter.lastModified, ascending: false)]
       fetchRequest.fetchLimit = 1
       
       context.performAndWait {
           do {
               if let existingCounter = try context.fetch(fetchRequest).first {
                   counter = existingCounter as! Counter
                   currentCount = Int(existingCounter.currentCount)
                   targetCount = Int(existingCounter.targetCount)
               } else {
                   // Create new counter
                   let newCounter = Counter(context: context)
                   newCounter.id = UUID()
                   newCounter.name = "Main Counter"
                   newCounter.createdAt = Date()
                   newCounter.lastModified = Date()
                   counter = newCounter
                   try? context.save()
               }
           } catch {
               print("Error loading counter: \(error)")
           }
       }
   }
}*/


/*class StitchCounterViewModel: ObservableObject {
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
*/
