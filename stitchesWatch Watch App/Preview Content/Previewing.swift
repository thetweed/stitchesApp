//
//  Previewing.swift
//  stitchesApp
//
//  Created by Laurie on 2/5/25.
//

import Foundation
import CoreData
import SwiftUI
import WatchConnectivity

class PreviewCoreDataManager {
    static let shared = PreviewCoreDataManager()
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    init() {
        container = NSPersistentContainer(name: "stitchesApp")

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error setting up preview CoreData: \(error.localizedDescription)")
            }
            print("Preview Core Data model loaded successfully")
            print("Model entities: \(self.container.managedObjectModel.entities.map { $0.name ?? "unnamed" })")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        createSampleData()
    }
    
    func createSampleData() {
        let context = container.viewContext
                let sampleProject1 = Project.create(in: context,
                                          name: "Sweater Project",
                                          projectType: "knitting")
        sampleProject1.status = "In Progress"
        
        let sampleCounter1 = Counter.create(in: context,
                                          name: "Sleeve Stitches",
                                          counterType: "stitch")
        sampleCounter1.currentCount = 0
        sampleCounter1.targetCount = 40
        sampleCounter1.project = sampleProject1
        
        let sampleCounter2 = Counter.create(in: context,
                                          name: "Body Rows",
                                          counterType: "row")
        sampleCounter2.currentCount = 0
        sampleCounter2.targetCount = 150
        sampleCounter2.project = sampleProject1
        
        let sampleProject2 = Project.create(in: context,
                                          name: "Scarf",
                                          projectType: "knitting")
        sampleProject2.status = "In Progress"
        
        let sampleCounter3 = Counter.create(in: context,
                                          name: "Pattern Repeat",
                                          counterType: "repeat")
        sampleCounter3.currentCount = 2
        sampleCounter3.targetCount = 8
        sampleCounter3.project = sampleProject2
        
        try? context.save()
    }
}

class PreviewWatchSessionManager: WatchSessionManager {
    static let previewShared = PreviewWatchSessionManager()
    
    override init(session: WCSession = .default) {
        super.init(session: session)
        print(">>> PreviewWatchSessionManager initialized")
        DispatchQueue.main.async {
            self.isReachable = true
        }
        print("Set is Reachable to true")
        self.isSessionActive = true
    }
    
    override func requestCounters() {
        print("Preview: Simulated requesting counters")
    }
    
    override func sendStitchCount(_ count: Int, forCounter counter: Counter) {
        print("Preview: Simulated sending count \(count) for counter \(counter.name)")
    }
    
    override func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isReachable = true
            self.isSessionActive = true
        }
    }
    
    override func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = true
        }
    }
}



struct PreviewContainer: ViewModifier {
    let manager = PreviewCoreDataManager.shared
    let sessionManager = PreviewWatchSessionManager.previewShared
    
    func body(content: Content) -> some View {
        content
            .environment(\.managedObjectContext, manager.viewContext)
            .environmentObject(sessionManager)
 //           .onAppear {
 //               sessionManager.activateSession()
  //          }
    }
}

extension View {
    func withPreviewContainer() -> some View {
        modifier(PreviewContainer())
    }
}

