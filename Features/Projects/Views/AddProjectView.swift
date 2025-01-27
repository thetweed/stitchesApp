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
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    init(viewContext: NSManagedObjectContext) {
        let newProject = Project(context: viewContext)
        _viewModel = StateObject(wrappedValue: ProjectAddEditViewModel(project: newProject, viewContext: viewContext))
    }
    
    var body: some View {
        NavigationStack {
            AddProjectFormView(viewModel: viewModel)
        }
    }
}
