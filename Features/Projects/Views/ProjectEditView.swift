//
//  ProjectEditView.swift
//  stitchesApp
//
//  Created by Laurie on 1/17/25.
//

import SwiftUI
import CoreData

struct ProjectEditView: View {
    @StateObject private var viewModel: ProjectAddEditViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(project: Project, viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: ProjectAddEditViewModel(project: project, viewContext: viewContext))
    }
    
    var body: some View {
        NavigationStack {
            ProjectEditFormView(viewModel: viewModel)
                .navigationTitle("Edit Project")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            viewModel.updateProject()
                            dismiss()
                        }
                        .disabled(!viewModel.isValid)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
        }
    }
}
