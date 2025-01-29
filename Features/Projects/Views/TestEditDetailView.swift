//
//  TestEditDetailView.swift
//  stitchesApp
//
//  Created by Laurie on 1/28/25.
//
import SwiftUI
import CoreData

/*struct TestEditDetailView: View {
    @ObservedObject var viewModel: ProjectAddEditViewModel
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest private var yarns: FetchedResults<Yarn>
    @State private var showingError = false
    @State private var errorMessage = ""
    
    init(viewModel: ProjectAddEditViewModel) {
        self.viewModel = viewModel
        _yarns = FetchRequest<Yarn>(
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Yarn.brand, ascending: true),
                NSSortDescriptor(keyPath: \Yarn.colorName, ascending: true)
            ]
        )
    }
    
    var body: some View {
        Form {
            projectDetailsSection
            patternNotesSection
            yarnSection
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private var projectDetailsSection: some View {
        Section(header: Text("Project Details")) {
            TextField("Project Name", text: $viewModel.name)
                .textInputAutocapitalization(.words)
            
            Picker("Status", selection: $viewModel.status) {
                ForEach(viewModel.statuses, id: \.self) {
                    Text($0)
                }
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
            ForEach(yarns, id: \.safeID) { yarn in
                YarnSelectionRow(
                    yarn: yarn,
                    isSelected: viewModel.yarns.contains(yarn),
                    onTap: {
                        toggleYarnSelection(yarn)
                    }
                )
            }
        } header: {
            Text("Select Yarns")
        } footer: {
            Text("Tap a yarn to add or remove it from the project")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private func toggleYarnSelection(_ yarn: Yarn) {
        if viewModel.yarns.contains(yarn) {
            viewModel.removeYarn(yarn)
        } else {
            viewModel.addYarn(yarn)
        }
    }
}


struct TestEditView: View {
    @StateObject private var viewModel: ProjectAddEditViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(project: Project, viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue:
            ProjectAddEditViewModel(project: project, viewContext: viewContext)
        )
    }
    
    var body: some View {
        NavigationStack {
            TestEditDetailView(viewModel: viewModel)
                .navigationTitle("Edit Project")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            save()
                        }
                        .disabled(!viewModel.isValid)
                    }
                }
                .interactiveDismissDisabled()
        }
    }
    
    private func save() {
        viewModel.updateProject()
        dismiss()
    }
}

struct TestEditDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Previewing(\.sampleProjects) { projects in
            TestEditView(
                project: projects[0],
                viewContext: CoreDataManager.shared.container.viewContext
            )
        }
    }
}

/*struct TestEditDetailView_Previews: PreviewProvider {
   static var previews: some View {
       NavigationView {
           Previewing(\.sampleProjects) { projects in
               TestEditDetailView(
                   viewModel: ProjectAddEditViewModel(
                       project: projects[0],
                       viewContext: CoreDataManager.shared.container.viewContext
                   )
               )
           }
       }
   }
}*/

/*private var yarnSection: some View {
    Section(header: Text("Select Yarns")) {
        // Display all available yarns with checkmarks
        ForEach(yarns, id: \.safeID) { yarn in
            HStack {
                YarnRowView(yarn: yarn)
                Spacer()
                if viewModel.yarns.contains(yarn) {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if viewModel.yarns.contains(yarn) {
                    viewModel.removeYarn(yarn)
                } else {
                    viewModel.addYarn(yarn)
                }
            }
        }
        
        // Display selected yarns count
        if !viewModel.yarns.isEmpty {
            HStack {
                Text("Selected yarns")
                Spacer()
                Text("\(viewModel.yarns.count)")
                    .foregroundColor(.gray)
            }
        }
    }
}*/

/*struct TestEditDetailView: View {
    @ObservedObject var viewModel: ProjectAddEditViewModel
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest private var yarns: FetchedResults<Yarn>
    @State private var showingError = false
    @State private var errorMessage = ""
    
    init(viewModel: ProjectAddEditViewModel) {
        self.viewModel = viewModel
        _yarns = FetchRequest<Yarn>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Yarn.colorName, ascending: true)]
        )
    }
    
    var body: some View {
        Form {
            projectDetailsSection
            patternNotesSection
            yarnSection
        }
    }
    
    private var projectDetailsSection: some View {
        Section(header: Text("Project Details")) {
            TextField("Project Name", text: $viewModel.name)
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
                    Text("Add pattern notes").foregroundColor(.gray)
                }
                .frame(height: 100)
        }
    }
    
    private var yarnSection: some View {
        Section(header: Text("Select Yarns")) {
            ForEach(yarns, id: \.safeID) { yarn in
                HStack {
                    YarnRowView(yarn: yarn)
                    Spacer()
                    if viewModel.yarns.contains(yarn) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if viewModel.yarns.contains(yarn) {
                        viewModel.removeYarn(yarn)
                    } else {
                        viewModel.addYarn(yarn)
                    }
                }
            }
        }
    }
}

struct TestEditView: View {
    @StateObject private var viewModel: ProjectAddEditViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(project: Project, viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: ProjectAddEditViewModel(project: project, viewContext: viewContext))
    }
    
    var body: some View {
        NavigationStack {
            TestEditDetailView(viewModel: viewModel)
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
}*/
*/
