//
//  CoreDataManager.swift
//  stitchesApp
//
//  Created by Laurie on 1/14/25.
//

import SwiftUI
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let container = NSPersistentContainer(name: "stitchesApp")
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
        let storeDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let storeURL = storeDirectory.appendingPathComponent("stitchesApp.sqlite")
        
        print("CoreData store URL: \(storeURL)")
        
        let description = NSPersistentStoreDescription()
        description.url = storeURL
        description.type = NSSQLiteStoreType
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load persistent stores: \(error)")
                fatalError("Error loading Core Data: \(error.localizedDescription)")
            }
            print("Successfully loaded persistent store at: \(description.url?.absoluteString ?? "unknown location")")
            
            // Add store metadata check
            if let metadata = try? NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType, at: storeURL, options: nil) {
                print("Store metadata: \(metadata)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // Add additional options for saving
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.retainsRegisteredObjects = true
    }
    
    func saveContext() {
        let context = container.viewContext
        
        // Only print debug info if there are changes or if we're forcing a debug print
        let insertedCount = context.insertedObjects.count
        let updatedCount = context.updatedObjects.count
        let deletedCount = context.deletedObjects.count
        
        if insertedCount > 0 || updatedCount > 0 || deletedCount > 0 {
            print("\n--- Beginning save attempt ---")
            print("Pending changes:")
            print("- Inserted objects: \(insertedCount)")
            print("- Updated objects: \(updatedCount)")
            print("- Deleted objects: \(deletedCount)")
            
            do {
                try context.save()
                print("Save successful!")
                
                // Verify current state after save
                let projectCount = try context.count(for: NSFetchRequest(entityName: "Project"))
                let yarnCount = try context.count(for: NSFetchRequest(entityName: "Yarn"))
                let counterCount = try context.count(for: NSFetchRequest(entityName: "Counter"))
                
                print("Current counts after save:")
                print("- Projects: \(projectCount)")
                print("- Yarns: \(yarnCount)")
                print("- Counters: \(counterCount)")
                print("--- Save completed ---\n")
            } catch {
                print("Save failed!")
                print("Error details: \(error as NSError)")
            }
        }
    }
/*    func saveContext() {
        let context = container.viewContext
        
        print("\n--- Beginning save attempt ---")
        print("Checking for changes in context...")
        
        // Check for pending changes
        let insertedCount = context.insertedObjects.count
        let updatedCount = context.updatedObjects.count
        let deletedCount = context.deletedObjects.count
        
        print("Pending changes:")
        print("- Inserted objects: \(insertedCount)")
        print("- Updated objects: \(updatedCount)")
        print("- Deleted objects: \(deletedCount)")
        
        if context.hasChanges {
            do {
                print("Changes detected, attempting to save...")
                try context.save()
                print("Save successful!")
                
                // Verify persistent store after save
                do {
                    let coordinator = container.persistentStoreCoordinator
                    let stores = coordinator.persistentStores
                    print("Persistent stores after save: \(stores.count)")
                    for store in stores {
                        print("Store URL: \(String(describing: store.url))")
                        print("Store type: \(store.type)")
                    }
                }
                
                // Verify current state after save
                let projectCount = try context.count(for: NSFetchRequest(entityName: "Project"))
                let yarnCount = try context.count(for: NSFetchRequest(entityName: "Yarn"))
                let counterCount = try context.count(for: NSFetchRequest(entityName: "Counter"))
                
                print("Current counts after save:")
                print("- Projects: \(projectCount)")
                print("- Yarns: \(yarnCount)")
                print("- Counters: \(counterCount)")
            } catch {
                print("Save failed!")
                print("Error details: \(error as NSError)")
                print("Error description: \(error.localizedDescription)")
            }
        } else {
            print("No changes detected in context")
            
            // Check current state anyway
            do {
                let projectCount = try context.count(for: NSFetchRequest(entityName: "Project"))
                let yarnCount = try context.count(for: NSFetchRequest(entityName: "Yarn"))
                let counterCount = try context.count(for: NSFetchRequest(entityName: "Counter"))
                
                print("Current counts in database:")
                print("- Projects: \(projectCount)")
                print("- Yarns: \(yarnCount)")
                print("- Counters: \(counterCount)")
            } catch {
                print("Error checking entity counts: \(error)")
            }
        }
        print("--- Save attempt completed ---\n")
    }*/
}

/*class CoreDataManager {
    static let shared = CoreDataManager()
    let container = NSPersistentContainer(name: "stitchesApp")
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
        let description = NSPersistentStoreDescription()
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        
        // Debug store location
        if let storeURL = description.url {
            print("CoreData store URL: \(storeURL)")
        }
        
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load persistent stores: \(error)")
                fatalError("Error loading Core Data: \(error.localizedDescription)")
            }
            print("Successfully loaded persistent store at: \(description.url?.absoluteString ?? "unknown location")")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func saveContext() {
        let context = container.viewContext
        
        // Debug current state
        print("\n--- Beginning save attempt ---")
        print("Checking for changes in context...")
        
        // Check for pending changes
        let insertedCount = context.insertedObjects.count
        let updatedCount = context.updatedObjects.count
        let deletedCount = context.deletedObjects.count
        
        print("Pending changes:")
        print("- Inserted objects: \(insertedCount)")
        print("- Updated objects: \(updatedCount)")
        print("- Deleted objects: \(deletedCount)")
        
        if context.hasChanges {
            do {
                print("Changes detected, attempting to save...")
                try context.save()
                print("Save successful!")
                
                // Verify current state after save
                let projectCount = try context.count(for: NSFetchRequest(entityName: "Project"))
                let yarnCount = try context.count(for: NSFetchRequest(entityName: "Yarn"))
                let counterCount = try context.count(for: NSFetchRequest(entityName: "Counter"))
                
                print("Current counts after save:")
                print("- Projects: \(projectCount)")
                print("- Yarns: \(yarnCount)")
                print("- Counters: \(counterCount)")
            } catch {
                print("Save failed!")
                print("Error details: \(error as NSError)")
                print("Error description: \(error.localizedDescription)")
            }
        } else {
            print("No changes detected in context")
            
            // Check current state anyway
            do {
                let projectCount = try context.count(for: NSFetchRequest(entityName: "Project"))
                let yarnCount = try context.count(for: NSFetchRequest(entityName: "Yarn"))
                let counterCount = try context.count(for: NSFetchRequest(entityName: "Counter"))
                
                print("Current counts in database:")
                print("- Projects: \(projectCount)")
                print("- Yarns: \(yarnCount)")
                print("- Counters: \(counterCount)")
            } catch {
                print("Error checking entity counts: \(error)")
            }
        }
        print("--- Save attempt completed ---\n")
    }
}*/

/*class CoreDataManager {
    
    static let shared = CoreDataManager()

    let container = NSPersistentContainer(name: "stitchesApp")

    var viewContext: NSManagedObjectContext {
            container.viewContext
        }
    
    private init() {
        
        let description = NSPersistentStoreDescription()
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading Core Data: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

    }
    
    func saveContext() {
            let context = container.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let error = error as NSError
                    print("ViewContext save error: \(error as NSError)")
                }
            }
        }
}*/

/*class CoreDataManager {
    
    static let shared = CoreDataManager()

    let container = NSPersistentContainer(name: "stitchesApp")

    var viewContext: NSManagedObjectContext {
            container.viewContext
        }
    
    private init() {
        
        let description = NSPersistentStoreDescription()
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading Core Data: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

    }
    
    func saveContext() {
            let context = container.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let error = error as NSError
                    print("ViewContext save error: \(error as NSError)")
                }
            }
        }
}*/
