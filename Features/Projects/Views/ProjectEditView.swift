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
    
    init(project: Project, viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: ProjectAddEditViewModel(
            project: project,
            viewContext: viewContext
        ))
    }
    
    var body: some View {
        ProjectFormView(viewModel: viewModel, isNewProject: false)
    }
}
