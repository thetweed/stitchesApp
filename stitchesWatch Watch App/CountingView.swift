//
//  CountingView.swift
//  stitchesApp
//
//  Created by Laurie on 2/5/25.
//
import SwiftUI
import CoreData
import WatchConnectivity

struct CountingView: View {
    let counter: Counter
    @ObservedObject var motionManager: MotionManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    //@ObservedObject private var sessionManager = WatchSessionManager.shared
    @EnvironmentObject private var sessionManager: WatchSessionManager
    @Binding var selectedCounter: Counter?
    
    var body: some View {
        VStack {
            
            Text(counter.name)
                .font(.headline)
            
            Text("\(motionManager.stitchCount)")
                .font(.system(.title, design: .rounded))
                .bold()
            
            HStack {
                Button(action: {
                    saveCount()
                }) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                }
                
                Button(action: {
                    selectedCounter = nil
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                }
            }
            
            if !sessionManager.isReachable {
                Text("iPhone not reachable")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
        }
        .onAppear{
            print("CountingView appeared")
            print("Session manager reachable state: \(sessionManager.isReachable)")
            print("Session manager instance: \(ObjectIdentifier(sessionManager))")
        }
    }
    
    private func saveCount() {
        counter.currentCount = Int32(motionManager.stitchCount)
        counter.lastModified = Date()
        
        do {
            try viewContext.save()
            sessionManager.sendStitchCount(motionManager.stitchCount, forCounter: counter)
        } catch {
            print("Error saving count: \(error)")
        }
    }
}

struct CountingView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PreviewCoreDataManager.shared.viewContext
        let sessionManager = PreviewWatchSessionManager.previewShared
        let counter = Counter.create(in: context, name: "Test Counter", counterType: "stitch")
        
        NavigationView {
            CountingView(
                counter: counter,
                motionManager: MotionManager(),
                selectedCounter: .constant(counter)
            )
            .environment(\.managedObjectContext, context)
            .environmentObject(sessionManager)
        }
    }
}

