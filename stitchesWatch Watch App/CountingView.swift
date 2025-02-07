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
    @StateObject private var motionManager: MotionManager
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var sessionManager: WatchSessionManager
    @Binding var selectedCounter: Counter?
    @Environment(\.dismiss) private var dismiss
    
    init(counter: Counter, selectedCounter: Binding<Counter?>) {
        self.counter = counter
        self._motionManager = StateObject(wrappedValue: MotionManager(initialCount: Int(counter.currentCount)))
        self._selectedCounter = selectedCounter
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text(counter.name)
                .font(.headline)
            
            Text("\(motionManager.stitchCount) / \(counter.targetCount)")
                .font(.system(.title, design: .rounded))
                .bold()
            
            Button(action: {
                saveCount()
            }) {
                Text("Save Count")
                    .font(.body)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            
            if !sessionManager.isReachable {
                Text("iPhone not reachable")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(false)  // Show the back button
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    motionManager.stopMotionDetection()
                    selectedCounter = nil
                }) {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .onAppear {
            print("CountingView appeared for counter: \(counter.name) with count: \(counter.currentCount)")
            motionManager.startMotionDetection()
        }
        .onDisappear {
            motionManager.stopMotionDetection()
        }
    }
    
    private func saveCount() {
        let count = motionManager.stitchCount
        print("Saving count \(count) for counter: \(counter.name)")
        
        viewContext.performAndWait {
            counter.currentCount = Int32(count)
            counter.lastModified = Date()
            
            do {
                try viewContext.save()
                print("Successfully saved count to local CoreData")
                
                sessionManager.sendStitchCount(count, forCounter: counter) { success in
                    if success {
                        print("Successfully synced count with phone")
                        // Return to selection view after successful save
                        DispatchQueue.main.async {
                            motionManager.stopMotionDetection()
                            selectedCounter = nil
                        }
                    } else {
                        print("Failed to sync count with phone")
                    }
                }
            } catch {
                print("Error saving count: \(error)")
            }
        }
    }
}

/*struct CountingView_Previews: PreviewProvider {
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
}*/

