//
//  AllCountersListView.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//

import SwiftUI
import CoreData

struct AllCountersView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        entity: Counter.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Counter.lastModified, ascending: false)
        ]
    ) var counters: FetchedResults<Counter>
    
    @State private var selectedFilter = CounterFilter.all
    @State private var searchText = ""
    
    enum CounterFilter {
        case all, row, stitch, repeating
        
        var predicate: NSPredicate? {
            switch self {
            case .all:
                return nil
            case .row:
                return NSPredicate(format: "counterType == %@", "row")
            case .stitch:
                return NSPredicate(format: "counterType == %@", "stitch")
            case .repeating:
                return NSPredicate(format: "counterType == %@", "repeat")
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredCounters.grouped()) { group in
                Section(header: Text(group.projectName)) {
                    ForEach(group.counters) { counter in
                        NavigationLink(destination: BasicStitchCounterView(context: context, counter: counter)) {
                            CounterRowView(counter: counter)
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search counters")
        .navigationTitle("All Counters")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Picker("Filter", selection: $selectedFilter) {
                        Text("All").tag(CounterFilter.all)
                        Text("Row Counters").tag(CounterFilter.row)
                        Text("Stitch Counters").tag(CounterFilter.stitch)
                        Text("Pattern Repeats").tag(CounterFilter.repeating)
                    }
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                }
            }
        }
    }
    
    var filteredCounters: [Counter] {
        var result = Array(counters)
        
        if let predicate = selectedFilter.predicate {
            result = result.filter { counter in
                predicate.evaluate(with: counter)
            }
        }
        
        if !searchText.isEmpty {
            result = result.filter { counter in
                counter.name.localizedCaseInsensitiveContains(searchText) ||
                counter.project?.name.localizedCaseInsensitiveContains(searchText) == true
            }
        }
        
        return result
    }
}

extension Array where Element == Counter {
    struct CounterGroup: Identifiable {
        let projectName: String
        let counters: [Counter]
        var id: String { projectName }
    }
    
    func grouped() -> [CounterGroup] {
        let grouped = Dictionary(grouping: self) { counter in
            counter.project?.name ?? "No Project"
        }
        
        return grouped.map { CounterGroup(projectName: $0, counters: $1) }
            .sorted { $0.projectName < $1.projectName }
    }
}

struct AllCountersView_Previews: PreviewProvider {
    static var previews: some View {
        Previewing(\.sampleCountersWithProjects) { _ in
            NavigationView {
                AllCountersView()
            }
        }
    }
}
