//
//  AllCountersListView.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//

import SwiftUI
import CoreData

/*struct AllCountersListView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        entity: Counter.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Counter.lastModified, ascending: false)]
    ) var counters: FetchedResults<Counter>
    
    var body: some View {
        List {
            ForEach(counters) { counter in
                NavigationLink {
                    StitchCounterView(context: context, counter: counter)
                } label: {
                    CounterRowView(counter: counter)
                }
            }
            .onDelete(perform: deleteCounters)
        }
        .navigationTitle("All Counters")
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
