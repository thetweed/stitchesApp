//
//  ProjectDetailView.swift
//  stitchesApp
//
//  Created by Laurie on 1/17/25.
//

import SwiftUI
import CoreData

struct ProjectDetailView: View {
    let project: Project
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ProjectDetailViewModel
 
    
    init(project: Project) {
        self.project = project
        let context = CoreDataManager.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: ProjectDetailViewModel(
            project: context.object(with: project.objectID) as! Project,
            context: context
        ))
    }
    
    var body: some View {
        Group {
            if viewModel.isDeleted {
                EmptyView()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if !viewModel.isDeleted {  // Extra safety check
                            projectHeader
                            projectDetails
                            patternNotesSection
                            yarnsSection
                            countersSection
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(viewModel.isDeleted ? "" : viewModel.project.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !viewModel.isDeleted {
                    Button {
                        viewModel.showingEditSheet.toggle()
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showingEditSheet) {
            NavigationStack {
                if !viewModel.isDeleted {  // Extra safety check
                    ProjectEditView(project: viewModel.project, viewContext: viewContext)
                }
            }
        }
        .onChange(of: viewModel.isDeleted) { _, isDeleted in
            if isDeleted {
                DispatchQueue.main.async {
                    dismiss()
                }
            }
        }
    }

    private var projectHeader: some View {
        Group {
            if !viewModel.isDeleted {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.statusText)
                        .font(.headline)
                    Text(viewModel.startDateText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(viewModel.lastModifiedText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    private var projectDetails: some View {
        Group {
            if !viewModel.isDeleted {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.currentRowText)
                        .font(.headline)
                        .padding(.vertical, 4)
                }
            }
        }
    }

    private var patternNotesSection: some View {
        Group {
            if !viewModel.isDeleted {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Pattern Notes", systemImage: "note.text")
                        .font(.headline)
                    Text(viewModel.patternNotes)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
    }

    private var yarnsSection: some View {
        Group {
            if !viewModel.isDeleted {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Yarns", systemImage: "circle.hexagongrid.fill")
                        .font(.headline)
                    
                    if viewModel.yarnsArray.isEmpty {
                        Text("No yarns added")
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    } else {
                        VStack(spacing: 8) {
                            ForEach(viewModel.yarnsArray, id: \.safeID) { yarn in
                                NavigationLink(destination: YarnDetailView(yarn: yarn)) {
                                    YarnRowView(yarn: yarn)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    viewModel.refreshYarns()
                    viewModel.debugYarns()
                }
                .onChange(of: viewModel.showingEditSheet) { oldValue, newValue in
                    if !newValue {
                        viewModel.refreshCounters()
                    }
                }
            }
        }
    }

    private var countersSection: some View {
        Group {
            if !viewModel.isDeleted {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Counters", systemImage: "number.circle.fill")
                        .font(.headline)
                    
                    if viewModel.counters.isEmpty {
                        Text("No counters attached")
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    } else {
                        VStack(spacing: 8) {
                            ForEach(viewModel.counters) { counter in
                                NavigationLink(destination: BasicStitchCounterView(context: viewContext, counter: counter)) {
                                    CounterRowView(counter: counter)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Previewing(\.sampleProjectWithYarns) { project in
            NavigationStack {
                ProjectDetailView(project: project)
                    .onAppear {
                        print("Preview project ID: \(project.id)")
                        print("Preview project yarns count: \(project.yarns?.count ?? 0)")
                        project.debugYarnRelationship() 
                    }
            }
        }
    }
}
