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
    let project: Project
    
    @FetchRequest(
        entity: Counter.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Counter.name, ascending: true)],
        predicate: NSPredicate(format: "project == nil"),
        animation: .default
    ) private var unattachedCounters: FetchedResults<Counter>
    
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
                        // Apply all changes when done is tapped
                        selectedCounters.forEach { counter in
                            counter.project = project
                            project.addToCounters(counter)
                        }
                        
                        do {
                            try viewContext.save()
                            print("Saved counter selections")
                        } catch {
                            print("Error saving counter selections: \(error)")
                        }
                        dismiss()
                    }
                }
            }
        }
    }
}

/*struct UnattachedCounterSelectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCounters: Set<Counter>
    
    @FetchRequest(
            entity: Counter.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Counter.name, ascending: true)],
            predicate: NSPredicate(format: "project == nil"),
            animation: .default
        ) private var unattachedCounters: FetchedResults<Counter>
    
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
                        // Try to save immediately
                        do {
                            try viewContext.save()
                            print("Saved counter selection")
                        } catch {
                            print("Error saving counter selection: \(error)")
                        }
                    }
                }
                .navigationTitle("Select Counters")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            // Final save attempt before dismissing
                            do {
                                try viewContext.save()
                                print("Final save of counter selections")
                            } catch {
                                print("Error in final save: \(error)")
                            }
                            dismiss()
                        }
                    }
                }
            }
        }
}
*/
