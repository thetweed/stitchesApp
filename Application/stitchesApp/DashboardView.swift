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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                welcomeSection
                statsGrid
                
                if !activeProjects.isEmpty {
                    recentProjectsSection
                }
                
                quickActionsSection
            }
            .padding()
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
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome to Stitches")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Track your knitting and crochet projects")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 8)
    }
    
    private var statsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatsCard(
                title: "Active Projects",
                value: "\(activeProjects.count)",
                systemImage: "square.stack.3d.up.fill",
                color: .blue
            )
            
            StatsCard(
                title: "Active Counters",
                value: "0", // Implement counter fetch
                systemImage: "number.circle.fill",
                color: .orange
            )
        }
    }
    
    private var recentProjectsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Projects")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                NavigationLink(destination: ProjectListView(viewContext: viewContext)) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            ForEach(Array(activeProjects.prefix(3))) { project in
                NavigationLink(destination: ProjectDetailView(project: project)) {
                    ProjectCard(project: project)
                }
            }
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(spacing: 16) {
                ActionButton(
                    title: "New Project",
                    systemImage: "plus.app.fill",
                    color: .blue
                ) {
                    showingAddProject = true
                }
                
                ActionButton(
                    title: "Add Yarn",
                    systemImage: "plus.circle.fill",
                    color: .green
                ) {
                    showingAddYarn = true
                }
            }
        }
    }
}

// Supporting Views

struct StatsCard: View {
    let title: String
    let value: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundColor(color)
                Spacer()
                Text(value)
                    .font(.title)
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
                .shadow(color: color.opacity(0.1), radius: 10, x: 0, y: 4)
        )
    }
}

struct ProjectCard: View {
    let project: Project
    
    var body: some View {
        HStack(spacing: 16) {
            // Project Image or Icon
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "square.stack.3d.up.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            // Project Details
            VStack(alignment: .leading, spacing: 4) {
                Text(project.name)
                    .font(.headline)
                
                Text(project.patternNotes ?? "No Pattern")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Progress Bar
                ProgressView(value: 0.6) // Replace with actual progress
                    .tint(.blue)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
}

struct ActionButton: View {
    let title: String
    let systemImage: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                action()
            }
        }) {
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
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
