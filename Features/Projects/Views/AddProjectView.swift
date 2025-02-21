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
        print("Initializing AddProjectView")
        _viewModel = StateObject(wrappedValue: ProjectAddEditViewModel(viewContext: viewContext))
    }
    
    var body: some View {
        ProjectFormView(viewModel: viewModel, isNewProject: true)
            .onDisappear {
                print("AddProjectView disappeared")
            }
    }
}
