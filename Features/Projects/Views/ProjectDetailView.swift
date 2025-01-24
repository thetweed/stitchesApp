//
//  ProjectDetailView.swift
//  stitchesApp
//
//  Created by Laurie on 1/17/25.
//

import SwiftUI
import CoreData

struct ProjectDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ProjectDetailViewModel
    
    init(project: Project) {
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
            ProjectEditView(project: viewModel.project, viewContext: viewContext)
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
        VStack(alignment: .leading, spacing: 8) {
            Text("Yarns")
                .font(.headline)
            if viewModel.hasYarns {
                ForEach(viewModel.yarns, id: \.self) { yarn in
                    Text(yarn.colorName)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            } else {
                Text("No yarns added")
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
}

/*struct ProjectDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
//    @ObservedObject var project: Project
    let project: Project
    @State private var showingEditSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                projectHeader
                projectDetails
                patternNotesSection
//                yarnsSection
            }
            .padding()
        }
        .navigationTitle(project.name)
        .toolbar {
            Button("Edit") {
                showingEditSheet.toggle()
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            ProjectEditView(project: project)
        }
    }
    
    private var projectHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Status: \(project.status)")
                .font(.headline)
            Text("Started: \(project.startDate)")
                .font(.subheadline)
            Text("Last modified: \(project.lastModified)")
                .font(.subheadline)
        }
    }
    
    private var projectDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Current Row: \(project.currentRow)")
                .font(.headline)
        }
    }
    
    private var patternNotesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Pattern Notes")
                .font(.headline)
            Text(project.patternNotes ?? "No pattern notes")
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    private var yarnsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Yarns")
                .font(.headline)
            if let yarns = project.yarns, !yarns.isEmpty {
                ForEach(Array(yarns), id: \.self) { yarn in
                    Text(yarn.colorName)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8) 
                }
            } else {
                Text("No yarns added")
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
     }
}*/

//#Preview {
 //   ProjectDetailView(project: <#Project#>)
//}

