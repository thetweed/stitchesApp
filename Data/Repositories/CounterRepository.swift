//
//  CounterRepository.swift
//  stitchesApp
//
//  Created by Laurie on 1/14/25.
//

import SwiftUI
import CoreData

class CounterRepository: Identifiable{
    
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        }
    
    // Save check
    private func save() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
        
    // Add a counter (Create)
    func createCounter(name: String, counterType: String) -> Counter {
        let counter = Counter.create(in: viewContext,
                                        name: name,
                                        counterType: counterType)
        save()
        return counter
        }
        
    // Read
    func fetchCounters() -> [Counter] {
        let request = NSFetchRequest<Counter>(entityName: "Counter")
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching projects: \(error)")
        }
        return []
        }
        
    // Update project, update date last modified
    func updateCounter(_ counter: Counter) {
        counter.lastModified = Date()
        save()
        }
        
    // Delete
    func deleteCounter(_ counter: Counter) {
        viewContext.delete(counter)
        save()
    }
    
}
