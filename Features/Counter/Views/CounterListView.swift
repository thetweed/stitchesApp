//
//  CounterListView.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//

import SwiftUI
import CoreData

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
