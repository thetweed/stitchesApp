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
        // Set up a fetch request for counters belonging to this project
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
            CounterSetupView(project: project)
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

/*struct CounterListView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var project: Project
    @FetchRequest var counters: FetchedResults<Counter>
    
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
                NavigationLink {
                    StitchCounterView(context: context, project: project, counter: counter)
                } label: {
                    CounterRowView(counter: counter)
                }
            }
            .onDelete(perform: deleteCounters)
        }
        .navigationTitle("Project Counters")
        .toolbar {
            EditButton()
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
*/
