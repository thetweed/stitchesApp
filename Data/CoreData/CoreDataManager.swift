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
}
