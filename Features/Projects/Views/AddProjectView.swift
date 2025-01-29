//
//  AddProjectView.swift
//  stitchesApp
//
//  Created by Laurie on 1/26/25.
//
import SwiftUI
import CoreData

struct AddProjectView: View {
    @StateObject private var viewModel: ProjectAddEditViewModel
    
    init(viewContext: NSManagedObjectContext) {
        let project = Project.create(
            in: viewContext,
            name: "",
            projectType: "knitting"
        )
        _viewModel = StateObject(wrappedValue: ProjectAddEditViewModel(
            project: project,
            viewContext: viewContext
        ))
    }
    
    var body: some View {
        ProjectFormView(viewModel: viewModel, isNewProject: true)
    }
}
