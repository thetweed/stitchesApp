//
//  ContentView.swift
//  stitchesWatch Watch App
//
//  Created by Laurie on 2/5/25.
//

import SwiftUI
import CoreData
import WatchConnectivity

struct ContentView: View {
    @StateObject private var motionManager = MotionManager()
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var sessionManager = WatchSessionManager.shared
    
    @State private var selectedCounter: Counter?
    
    var body: some View {
        NavigationView {
            if let counter = selectedCounter {
                CountingView(
                    counter: counter,
                    motionManager: motionManager,
                    selectedCounter: $selectedCounter
                )
            } else {
                CounterSelectionView(selectedCounter: $selectedCounter)
            }
        }
        .environmentObject(sessionManager)
        .onAppear {
                print("ContentView appeared")
                print("Session manager instance: \(ObjectIdentifier(sessionManager))")
                print("Session manager reachable state: \(sessionManager.isReachable)")
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    struct DebugWrapper: View {
        let sessionManager: WatchSessionManager
        
        var body: some View {
            ContentView()
                .environment(\.managedObjectContext, PreviewCoreDataManager.shared.viewContext)
                .environmentObject(sessionManager)
                .onAppear {
                    print("Preview setup - session manager instance: \(ObjectIdentifier(sessionManager))")
                }
        }
    }
    
    static var previews: some View {
        DebugWrapper(sessionManager: PreviewWatchSessionManager.previewShared)
    }
}
