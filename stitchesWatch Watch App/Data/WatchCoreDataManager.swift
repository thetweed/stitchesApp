//
//  WatchCoreDataManager.swift
//  stitchesApp
//
//  Created by Laurie on 2/5/25.
//

import CoreData
import WatchKit
import Combine

class WatchCoreDataManager: NSObject, ObservableObject {
    static let shared = WatchCoreDataManager()
    let container: NSPersistentContainer
    
    @Published var lastSaveDate: Date?
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    private override init() {
        container = NSPersistentContainer(name: "stitchesApp")
        
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("stitchesApp.sqlite")
        
        let description = NSPersistentStoreDescription()
        description.url = storeURL
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.persistentStoreDescriptions = [description]
        
        super.init()
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Watch CoreData error: \(error)")
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
