//
//  ProjectFormView.swift
//  stitchesApp
//
//  Created by Laurie on 1/28/25.
//

import SwiftUI
import CoreData

struct ProjectFormView: View {
    @ObservedObject var viewModel: ProjectAddEditViewModel
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    let isNewProject: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                projectDetailsSection
                patternNotesSection
                yarnSection
                counterSection
            }
            .navigationTitle(isNewProject ? "New Project" : "Edit Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: toolbarContent)
        }
        .sheet(isPresented: $viewModel.showingNewCounterSheet) {
            CounterSetupView { counter in
                viewModel.handleNewCounter(counter)
            }
        }
        
        .sheet(isPresented: $viewModel.showingAttachCounterSheet) {
            if isNewProject {
                UnattachedCounterSelectionView(
                    selectedCounters: $viewModel.countersToAttach,
                    project: nil
                )
                .onDisappear {
                    viewModel.refreshAttachedCounters()
                }
            } else if let project = viewModel.existingProject {
                UnattachedCounterSelectionView(
                    selectedCounters: $viewModel.countersToAttach,
                    project: project
                )
                .onDisappear {
                    viewModel.refreshAttachedCounters()
                }
            }
        }
    }
    
    private var projectDetailsSection: some View {
        Section(header: Text("Project Details")) {
            TextField("Project Name", text: $viewModel.name)
                .textInputAutocapitalization(.words)
            
            Picker("Status", selection: $viewModel.status) {
                ForEach(viewModel.statuses, id: \.self) { Text($0) }
            }
            
            TextField("Current Row", value: $viewModel.currentRow, formatter: NumberFormatter())
                .keyboardType(.numberPad)
        }
    }
    
    private var patternNotesSection: some View {
        Section(header: Text("Pattern Notes")) {
            TextEditor(text: $viewModel.patternNotes)
                .placeholder(when: viewModel.patternNotes.isEmpty) {
                    Text("Add pattern notes")
                        .foregroundColor(.gray)
                }
                .frame(minHeight: 100)
        }
    }
    
    private var yarnSection: some View {
        Section {
            Button(action: {
                viewModel.showYarnSelection = true
            }) {
                Label("Select Yarns", systemImage: "plus.circle")
            }
            
            ForEach(viewModel.sortedYarns, id: \.safeID) { yarn in
                YarnRowView(yarn: yarn)
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.removeYarn(yarn)
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
            }
        }
        .navigationDestination(isPresented: $viewModel.showYarnSelection) {
            YarnSelectionView(selectedYarns: $viewModel.yarns, viewContext: viewContext)
        }
    }
    
    private var counterSection: some View {
        Section(header: Text("Counters")) {
            Button(action: {
                viewModel.showingNewCounterSheet.toggle()
            }) {
                Label("Add New Counter", systemImage: "plus.circle")
            }
            
            Button(action: {
                viewModel.showingAttachCounterSheet.toggle()
            }) {
                Label("Attach Existing Counter", systemImage: "link")
            }
            
            LazyVStack(alignment: .leading, spacing: 8) {
                ForEach(viewModel.attachedCounters, id: \.safeID) { counter in
                    CounterRowView(counter: counter)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.detachCounter(counter)
                            } label: {
                                Label("Detach", systemImage: "link.badge.minus")
                            }
                        }
                }
            }
        }
    }
    
    @ToolbarContentBuilder
        private func toolbarContent() -> some ToolbarContent {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    if isNewProject {
                        viewModel.saveProject()
                    } else {
                        viewModel.updateProject()
                    }
                    dismiss()
                }
                .disabled(!viewModel.isValid)
            }
        }
}
