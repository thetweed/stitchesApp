//
//  DashboardView.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//

import SwiftUI
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.startDate, ascending: false)],
        predicate: NSPredicate(format: "status == %@", "In Progress")
    ) private var activeProjects: FetchedResults<Project>
    
    @State private var showingAddProject = false
    @State private var showingAddYarn = false
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome Back")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Track your progress and manage your projects")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 4)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Welcome Section
                    welcomeSection
                    
                    // Stats Section
                    statsSection
                    
                    // Active Projects Section
                    if !activeProjects.isEmpty {
                        projectSection(
                            title: "Active Projects",
                            systemImage: "flag.pattern.checkered",
                            projects: Array(activeProjects.prefix(3)),
                            accentColor: .blue
                        )
                    }
                    
                    // Quick Actions Section
                    quickActionsSection
                    
                    if activeProjects.isEmpty {
                        emptyStateView
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
                .frame(maxWidth: 650) // Constrain maximum width
                .frame(maxWidth: .infinity) // Center horizontally
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddProject = true
                    } label: {
                        Label("Add Project", systemImage: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddProject) {
            NavigationStack {
                AddProjectView(viewContext: viewContext)
            }
        }
        .sheet(isPresented: $showingAddYarn) {
            NavigationStack {
                AddYarnView(viewModel: AddYarnViewModel(viewContext: viewContext))
            }
        }
    }
    
    private var statsSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            statsCard(
                title: "Active Projects",
                value: "\(activeProjects.count)",
                systemImage: "flag.pattern.checkered",
                color: .blue
            )
            
            statsCard(
                title: "Active Counters",
                value: "0", // Implement counter fetch
                systemImage: "number.circle.fill",
                color: .orange
            )
        }
    }
    
    private func projectSection(title: String, systemImage: String, projects: [Project], accentColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(title, systemImage: systemImage)
                    .font(.headline)
                    .foregroundStyle(accentColor)
                
                Spacer()
                
                NavigationLink(destination: ProjectListView(viewContext: viewContext)) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(accentColor)
                }
            }
            .padding(.leading, 4)
            
            VStack(spacing: 12) {
                ForEach(projects) { project in
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
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Quick Actions", systemImage: "bolt.fill")
                .font(.headline)
                .foregroundStyle(.purple)
                .padding(.leading, 4)
            
            HStack(spacing: 16) {
                quickActionButton(
                    title: "New Project",
                    systemImage: "plus.app.fill",
                    color: .blue
                ) {
                    showingAddProject = true
                }
                
                quickActionButton(
                    title: "Add Yarn",
                    systemImage: "circle.hexagongrid.fill",
                    color: .green
                ) {
                    showingAddYarn = true
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.stack.3d.up")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text("No Active Projects")
                .font(.headline)
            
            Text("Tap the + button to start your first project")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    private func statsCard(title: String, value: String, systemImage: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundColor(color)
                Spacer()
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
    
    private func quickActionButton(title: String, systemImage: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.title2)
                Text(title)
                    .font(.callout)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.2), lineWidth: 1)
            )
            .foregroundColor(color)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct DashboardView_Previews: PreviewProvider {
    static let context = CoreDataManager.shared.container.viewContext
    
    static var previews: some View {
        let sampleData = PreviewingData()
        let _ = sampleData.sampleProjects(context)
        let _ = sampleData.sampleYarns(context)
        return DashboardView()
            .environment(\.managedObjectContext, context)
    }
}
