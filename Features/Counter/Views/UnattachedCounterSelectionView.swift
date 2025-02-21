//
//  UnattachedCounterSelectionView.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//

import SwiftUI
import CoreData

struct UnattachedCounterSelectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCounters: Set<Counter>
    let project: Project?
    
    @FetchRequest private var unattachedCounters: FetchedResults<Counter>
    
    init(selectedCounters: Binding<Set<Counter>>, project: Project?) {
        self._selectedCounters = selectedCounters
        self.project = project
        
        self._unattachedCounters = FetchRequest(
            entity: Counter.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Counter.lastModified, ascending: false)],
            predicate: NSPredicate(format: "project == nil"),
            animation: .default
        )
    }
    
    var body: some View {
        NavigationStack {
            List(unattachedCounters, id: \.safeID) { counter in
                HStack {
                    CounterRowView(counter: counter)
                    Spacer()
                    if selectedCounters.contains(counter) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedCounters.contains(counter) {
                        selectedCounters.remove(counter)
                    } else {
                        selectedCounters.insert(counter)
                    }
                }
            }
            .navigationTitle("Select Counters")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewContext.performAndWait {
                            selectedCounters.forEach { counter in
                                if let project = project {
                                    counter.project = project
                                    project.addToCounters(counter)
                                    counter.lastModified = Date()
                                }
                            }
                            
                            do {
                                try viewContext.save()
                                print("Saved counter selections successfully")
                            } catch {
                                print("Error saving counter selections: \(error)")
                            }
                        }
                        dismiss()
                    }
                }
            }
        }
        .onDisappear {
            NotificationCenter.default.post(
                name: NSNotification.Name("CountersUpdated"),
                object: nil
            )
        }
    }
}

