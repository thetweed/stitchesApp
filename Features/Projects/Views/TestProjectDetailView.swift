//
//  TestProjectDetailView.swift
//  stitchesApp
//
//  Created by Laurie on 1/28/25.
//

import SwiftUI
import CoreData

struct TestProjectDetailView: View {
    let project: Project
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ProjectDetailViewModel
    
    init(project: Project) {
        self.project = project
        _viewModel = StateObject(wrappedValue: ProjectDetailViewModel(project: project))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                projectHeader
                projectDetails
                patternNotesSection
                yarnsSection
            }
            .padding()
        }
        .navigationTitle(viewModel.project.name)
        .toolbar {
            Button("Edit") {
                viewModel.showingEditSheet.toggle()
            }
        }
        .sheet(isPresented: $viewModel.showingEditSheet) {
            TestEditView(project: viewModel.project, viewContext: viewContext)
        }
    }
    
    private var projectHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.statusText)
                .font(.headline)
            Text(viewModel.startDateText)
                .font(.subheadline)
            Text(viewModel.lastModifiedText)
                .font(.subheadline)
        }
    }
    
    private var projectDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.currentRowText)
                .font(.headline)
        }
    }
    
    private var patternNotesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Pattern Notes")
                .font(.headline)
            Text(viewModel.patternNotes)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    private var yarnsSection: some View {
        Section(header: Text("Yarns")) {
            if viewModel.yarns.isEmpty {
                Text("No yarns added")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.sortedYarns, id: \.safeID) { yarn in
                    YarnRowView(yarn: yarn)
                }
            }
        }
        .onAppear {
            #if DEBUG
            print("🧶 Debugging Project Yarns:")
            print("Project ID: \(project.id.uuidString)")
            print("Project Name: \(project.name)")
            
            // Check CoreData relationship
            if let yarnsSet = project.yarns {
                print("Number of yarns in CoreData: \(yarnsSet.count)")
                yarnsSet.forEach { yarn in
                    print("- Yarn: \(yarn.colorName), ID: \(yarn.id.uuidString)")
                }
            } else {
                print("No yarns relationship found in CoreData")
            }
            
            // Check ViewModel yarns
            print("\nViewModel Yarns Count: \(viewModel.yarns.count)")
            print("Sorted Yarns Count: \(viewModel.sortedYarns.count)")
            #endif
        }
    }

}

struct TestProjectDetailView_Previews: PreviewProvider {
   static let context = CoreDataManager.shared.container.viewContext
   
    static var previews: some View {
        let sampleData = PreviewingData()
        let projects = sampleData.sampleProjects(context)
        return NavigationStack {
            TestProjectDetailView(project: projects[0])
                .environment(\.managedObjectContext, context)
        }
    }
}


/*private var yarnsSection: some View {
    Section(header: Text("Yarns")) {
        if viewModel.yarns.isEmpty {
            Text("No yarns added")
                .foregroundColor(.secondary)
        } else {
            ForEach(viewModel.sortedYarns, id: \.safeID) { yarn in
                YarnRowView(yarn: yarn)
            }
        }
    }
}*/
