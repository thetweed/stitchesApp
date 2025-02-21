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
        
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.retainsRegisteredObjects = true
    }
    
    func saveContext() {
        let context = container.viewContext
        
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
    
}

