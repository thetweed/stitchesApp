//
//  stitchesWatchApp.swift
//  stitchesWatch Watch App
//
//  Created by Laurie on 2/5/25.
//

import SwiftUI
import CoreData

@main
struct StitchesWatchApp: App {
    @StateObject private var coreDataManager = WatchCoreDataManager.shared
    @StateObject private var sessionManager = WatchSessionManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataManager.viewContext)
                .environmentObject(sessionManager)  
        }
    }
}
