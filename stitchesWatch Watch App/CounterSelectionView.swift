//
//  CounterSelectionView.swift
//  stitchesApp
//
//  Created by Laurie on 2/5/25.
//

import SwiftUI
import CoreData
import WatchConnectivity

struct CounterSelectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var sessionManager: WatchSessionManager
    @Binding var selectedCounter: Counter?
    @FetchRequest private var activeProjects: FetchedResults<Project>
    
    init(selectedCounter: Binding<Counter?>) {
        self._selectedCounter = selectedCounter
        
        let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.lastModified, ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "status != %@", "Completed")
        
        self._activeProjects = FetchRequest<Project>(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        List {
            if !sessionManager.isSessionActive {
                Text("Connecting to iPhone...")
                    .foregroundColor(.gray)
            } else if activeProjects.isEmpty {
                Text("No projects found")
                    .foregroundColor(.gray)
            } else {
                ForEach(activeProjects) { project in
                    if let counters = project.counters?.allObjects as? [Counter],
                       !counters.isEmpty {
                        Section(header: Text(project.name)) {
                            ForEach(counters.sorted(by: { $0.lastModified > $1.lastModified })) { counter in
                                Button(action: {
                                    selectedCounter = counter
                                }) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(counter.name)
                                                .font(.headline)
                                            Text("\(counter.currentCount)/\(counter.targetCount)")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Image(systemName: counterTypeIcon(counter.counterType))
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Counter")
        .onAppear {
            print("Watch: CounterSelectionView appeared")
            print("Watch: Session active: \(sessionManager.isSessionActive)")
            print("Watch: Number of active projects: \(activeProjects.count)")
            for project in activeProjects {
                print("Watch: Project '\(project.name)' has \(project.counters?.count ?? 0) counters")
            }
            sessionManager.requestCounters()
        }
        .onChange(of: sessionManager.counters) { oldValue, newValue in
            print("Watch: Counter list updated, now showing \(newValue.count) counters")
        }
        .overlay(Group {
            if !sessionManager.isReachable {
                VStack {
                    Image(systemName: "iphone.slash")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("iPhone not connected")
                        .foregroundColor(.gray)
                }
            }
        })
    }
    
    private func counterTypeIcon(_ type: String) -> String {
        switch type {
        case "row":
            return "arrow.left.and.right"
        case "stitch":
            return "circle"
        case "repeat":
            return "repeat"
        default:
            return "questionmark"
        }
    }
}

/*
struct CounterSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = PreviewCoreDataManager.shared
        let sessionManager = PreviewWatchSessionManager.previewShared
        
        NavigationView {
            CounterSelectionView(selectedCounter: .constant(nil))
                .environment(\.managedObjectContext, manager.viewContext)
                .environmentObject(sessionManager)
        }
    }
}
*/
