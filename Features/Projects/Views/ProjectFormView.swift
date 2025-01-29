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
            }
            .navigationTitle(isNewProject ? "New Project" : "Edit Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
            NavigationLink {
                YarnSelectionView(selectedYarns: $viewModel.yarns, viewContext: viewContext)
            } label: {
                HStack {
                    Text("Select Yarns")
                    Spacer()
                    Text("\(viewModel.yarns.count) selected")
                        .foregroundColor(.secondary)
                }
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
    }
}
