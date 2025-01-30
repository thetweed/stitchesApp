//
//  CounterNavigationView.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//

import SwiftUI
import CoreData

struct CounterHomeView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        entity: Counter.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Counter.lastModified, ascending: false)],
        predicate: nil,
        animation: .default
    ) var counters: FetchedResults<Counter>
    
    @State private var showingNewCounter = false
    @State private var expandedProjects: Set<Project> = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    if !counters.isEmpty {
                        recentActivitySection
                        projectCountersSection
                        allCountersSection  // Moved inside the if !counters.isEmpty condition
                    } else {
                        emptyStateView
                    }
                }
                .padding()
            }
            .navigationTitle("Counter Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingNewCounter = true
                    } label: {
                        Label("Add Counter", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewCounter) {
                CounterSetupView()
            }
        }
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Recent Activity", systemImage: "clock.fill")
                .font(.headline)
                .foregroundStyle(.blue)
                .padding(.leading, 4)
            
            VStack(spacing: 12) {
                ForEach(Array(counters.prefix(3))) { counter in
                    NavigationLink(destination: BasicStitchCounterView(context: context, counter: counter)) {
                        CounterRowView(counter: counter)
                            .cardStyle()
                    }
                }
            }
        }
    }
    
    private var projectCountersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Project Counters", systemImage: "folder.fill")
                .font(.headline)
                .foregroundStyle(.blue)
                .padding(.leading, 4)
            
            let projectsWithCounters = Array(Set(counters.compactMap { $0.project }))
            
            if projectsWithCounters.isEmpty {
                Text("No projects with counters")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                ForEach(projectsWithCounters, id: \.safeID) { project in
                    ProjectCountersRow(
                        project: project,
                        isExpanded: expandedProjects.contains(project),
                        onTap: {
                            if expandedProjects.contains(project) {
                                expandedProjects.remove(project)
                            } else {
                                expandedProjects.insert(project)
                            }
                        }
                    )
                }
            }
        }
    }
    
    private var allCountersSection: some View {
        NavigationLink(destination: AllCountersView()) {
            HStack {
                VStack(alignment: .leading) {
                    Text("View All Counters")
                        .font(.subheadline)
                    Text("See your complete counter list")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "number.circle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text("No Counters Yet")
                .font(.headline)
            
            Text("Tap the + button to add your first counter")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}


struct CounterHomeView_Previews: PreviewProvider {
    static var previews: some View {
        Previewing(\.sampleCountersWithProjects) { _ in
            CounterHomeView()
        }
    }
}
