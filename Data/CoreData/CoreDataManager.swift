//
//  CoreDataManager.swift
//  stitchesApp
//
//  Created by Laurie on 1/14/25.
//

import SwiftUI
import CoreData

class CoreDataManager {
    
    // Shared access for easy access throughout the app
    static let shared = CoreDataManager()
    
    // Persistent container
    let container = NSPersistentContainer(name: "stitchesApp")
    
    // Convenience accessor for view context
    var viewContext: NSManagedObjectContext {
            container.viewContext
        }
    
    func saveContext() {
            let context = container.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let error = error as NSError
                    print("Unresolved Core Data error \(error), \(error.userInfo)")
                }
            }
        }

    // Initialize the persistent container
    private init() {
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading Core Data: \(error.localizedDescription)")
            }
        }
        
        // Enable automatic merging of changes
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // If a conflict occurs, let the latest version win
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

    }
}
