//
//  ProjectListView.swift
//  stitchesApp
//
//  Created by Laurie on 1/17/25.
//

import SwiftUI
import CoreData

struct ProjectListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ProjectListViewModel
    @FetchRequest private var projects: FetchedResults<Project>
    
    init(viewContext: NSManagedObjectContext) {
        let vm = ProjectListViewModel(viewContext: viewContext)
        _viewModel = StateObject(wrappedValue: vm)
        _projects = FetchRequest(fetchRequest: vm.projectFetchRequest())
    }
    
    private var activeProjects: [Project] {
        projects.filter { $0.status == "In Progress" }
    }

    private var plannedProjects: [Project] {
        projects.filter { $0.status == "Not Started" }
    }

    private var completedProjects: [Project] {
        projects.filter { $0.status == "Completed" || $0.status == "Frogged" }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    if projects.isEmpty {
                        emptyStateView
                    } else {
                        if !activeProjects.isEmpty {
                            projectSection(
                                title: "Active Projects",
                                systemImage: "flag.pattern.checkered",
                                projects: activeProjects,
                                accentColor: .blue
                            )
                        }
                        
                        if !plannedProjects.isEmpty {
                            projectSection(
                                title: "Planned",
                                systemImage: "doc.text",
                                projects: plannedProjects,
                                accentColor: Color(.darkGray)
                            )
                        }
                        
                        if !completedProjects.isEmpty {
                            projectSection(
                                title: "Finished Projects",
                                systemImage: "checkmark.circle",
                                projects: completedProjects,
                                accentColor: .green
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Knitting Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.toggleAddProject()
                    } label: {
                        Label("Add Project", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddProject) {
                NavigationStack {
                    AddProjectView(viewContext: viewContext)
                }
            }
            .onAppear {
                print("Projects count: \(projects.count)")
                print("Projects is empty: \(projects.isEmpty)")
            }
        }
    }
    
    private func projectSection(title: String, systemImage: String, projects: [Project], accentColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(accentColor)
                .padding(.leading, 4)
            
            VStack(spacing: 12) {
                ForEach(projects, id: \.safeID) { project in
                    NavigationLink(destination: ProjectDetailView(project: project)) {
                        ProjectRowView(project: project)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                            )
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.stack.3d.up")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text("No Projects Yet")
                .font(.headline)
            
            Text("Tap the + button to add your first knitting project")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static let context = CoreDataManager.shared.container.viewContext
    
    static var previews: some View {
        let sampleData = PreviewingData()
        let _ = sampleData.sampleProjects(context)
        return ProjectListView(viewContext: context)
            .environment(\.managedObjectContext, context)
    }
}
