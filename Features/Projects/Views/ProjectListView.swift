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
   @FetchRequest(sortDescriptors: []) private var projects: FetchedResults<Project>
   
   init(viewContext: NSManagedObjectContext) {
       let vm = ProjectListViewModel(viewContext: viewContext)
       _viewModel = StateObject(wrappedValue: vm)
       _projects = FetchRequest(fetchRequest: vm.projectFetchRequest())
   }
   
   var body: some View {
       NavigationStack {
           List {
               ForEach(projects, id: \.safeID) { project in
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
               AddProjectFormView(
                   viewModel: ProjectAddEditViewModel(
                       project: Project(context: viewContext),
                       viewContext: viewContext
                   )
               )
           }
       }
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

/*
 .sheet(isPresented: $viewModel.showingAddProject) {
                 let addEditViewModel = ProjectAddEditViewModel(
                     project: Project(context: viewContext),
                     viewContext: viewContext
                 )
                 AddProjectFormView(viewModel: addEditViewModel)
                     .environment(\.managedObjectContext, viewContext)
             }
 */
