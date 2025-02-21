//
//  ProjectEditView.swift
//  stitchesApp
//
//  Created by Laurie on 1/17/25.
//

import SwiftUI
import CoreData

struct ProjectEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel: ProjectAddEditViewModel
    
    init(project: Project, viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: ProjectAddEditViewModel(
            project: project,
            viewContext: viewContext
        ))
    }
    
    var body: some View {
        ProjectFormView(viewModel: viewModel, isNewProject: false)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        viewModel.showingDeleteAlert = true
                    } label: {
                        Label("Delete Project", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .alert("Delete Project?", isPresented: $viewModel.showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    viewModel.deleteProject()
                }
            } message: {
                Text("This will permanently delete this project and all its counters. This action cannot be undone.")
            }
            .onChange(of: viewModel.isDeleted) { _, isDeleted in
                if isDeleted {
                    // Both dismiss and presentationMode for better compatibility
                    dismiss()
                    presentationMode.wrappedValue.dismiss()
                }
            }
    }
}


