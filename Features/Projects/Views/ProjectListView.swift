//
//  ProjectListView.swift
//  stitchesApp
//
//  Created by Laurie on 1/17/25.
//

import SwiftUI
import CoreData

struct ProjectListView: View {
    @StateObject private var viewModel: ProjectListViewModel
    @FetchRequest private var projects: FetchedResults<Project>
    
    init(viewContext: NSManagedObjectContext) {
        let vm = ProjectListViewModel(viewContext: viewContext)
        _viewModel = StateObject(wrappedValue: vm)
        _projects = FetchRequest(fetchRequest: vm.projectFetchRequest())
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(projects) { project in
                    NavigationLink(destination: ProjectDetailView(project: project)) {
                        ProjectRowView(project: project)
                    }
                }
            }
            .navigationTitle("Knitting Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.toggleAddProject) {
                        Label("Add Project", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddProject) {
                AddProjectFormView(viewContext: viewModel.viewContext)
            }
        }
    }
}


/*struct ProjectListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.lastModified, ascending: false)],
        predicate: NSPredicate(format: "deleted == NO")
    ) private var projects: FetchedResults<Project>
    
    @State private var showingAddProject = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(projects) { project in
                    NavigationLink(destination: ProjectDetailView(project: project)) {
                        ProjectRowView()
                    }
                }

            }
            .navigationTitle("Knitting Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddProject.toggle() }) {
                        Label("Add Project", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddProject) {
                ProjectFormView()
            }
        }
    }
}
/*
                .onDelete(perform: deleteProjects)
 private func deleteProjects(offsets: IndexSet) {
        withAnimation {
            offsets.map { projects[$0] }.forEach { project in
                project.deleted = true
                project.lastmodified = Date()
            }
            try? viewContext.save()
        }
    }*/
*/

//#Preview {
//    ProjectListView()
//}

