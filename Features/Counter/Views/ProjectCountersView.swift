//
//  CounterListView.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//

import SwiftUI
import CoreData

struct ProjectCountersView: View {
    @Environment(\.managedObjectContext) private var context
    @State private var showingAddCounter = false
    @FetchRequest var counters: FetchedResults<Counter>
    let project: Project
    
    init(project: Project) {
        self.project = project
        _counters = FetchRequest(
            entity: Counter.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Counter.lastModified, ascending: false)],
            predicate: NSPredicate(format: "project == %@", project)
        )
    }
    
    var body: some View {
        List {
            ForEach(counters) { counter in
                NavigationLink(destination: BasicStitchCounterView(context: context, counter: counter)) {
                    CounterRowView(counter: counter)
                }
            }
            .onDelete(perform: deleteCounters)
        }
        .navigationTitle("\(project.name) Counters")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddCounter = true }) {
                    Label("Add Counter", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCounter) {
            CounterSetupView()
        }
    }
    
    private func deleteCounters(at offsets: IndexSet) {
        for index in offsets {
            let counter = counters[index]
            context.delete(counter)
        }
        
        do {
            try context.save()
        } catch {
            print("Error deleting counter: \(error)")
        }
    }
}

struct ProjectCountersView_Previews: PreviewProvider {
    static var previews: some View {
        Previewing(\.sampleProjectWithCounter) { project in
            NavigationView {
                ProjectCountersView(project: project)
            }
        }
    }
}

