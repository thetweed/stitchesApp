//
//  ProjectFormView.swift
//  stitchesApp
//
//  Created by Laurie on 1/17/25.
//

import SwiftUI
import CoreData

struct AddProjectFormView: View {
    @ObservedObject var viewModel: ProjectAddEditViewModel
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            NavigationStack {
                Form {
                    projectDetailsSection
                    patternNotesSection
                    yarnSection
                }
                .navigationTitle("New Project")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            viewModel.saveProject()
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
                       .multilineTextAlignment(.center)
               }
               .frame(height: 100)
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
                        .foregroundColor(.gray)
                }
            }
            
            ForEach(viewModel.sortedYarns, id: \.safeID) { yarn in
                YarnRowView(yarn: yarn)
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.removeYarn(yarn)
                        } label: {
                            Label("Remove", systemImage: "minus.circle")
                        }
                    }
            }
        }
    }
}

struct AddProjectFormView_Previews: PreviewProvider {
   static var previews: some View {
       NavigationView {
           Previewing(\.sampleProjects) { projects in
               AddProjectFormView(
                   viewModel: ProjectAddEditViewModel(
                       project: projects[0],
                       viewContext: CoreDataManager.shared.container.viewContext
                   )
               )
           }
       }
   }
}

/*struct AddProjectFormView: View {
    @ObservedObject var viewModel: ProjectAddEditViewModel
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
                    Form {
                        projectDetailsSection
                        patternNotesSection
                        yarnSection
                    }
                    .navigationTitle("New Project")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                dismiss()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                viewModel.saveProject()
                                dismiss()
                            }
                            .disabled(!viewModel.isValid)
                        }
                    }
                }
    }*/
/*var body: some View {
    Form {
        projectDetailsSection
        patternNotesSection
        yarnSection
    }
    .navigationTitle("New Project")
    .toolbar {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                dismiss()
            }
        }
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
                viewModel.saveProject()
                dismiss()
            }
            .disabled(!viewModel.isValid)
        }
    }
}*/

/*struct AddProjectFormView: View {
    @StateObject private var viewModel: AddProjectViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(project: Project, viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: AddProjectViewModel(project: project, viewContext: viewContext))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Project Details")) {
                    TextField("Project Name", text: $viewModel.name)
                    Picker("Status", selection: $viewModel.status) {
                        ForEach(viewModel.statuses, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Current Row", value: $viewModel.currentRow, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Pattern Notes")) {
                    TextEditor(text: $viewModel.patternNotes)
                        .frame(height: 100)
                }
                
                Section(header: Text("Yarns")) {
                    Text("Yarns")
                        .frame(height: 100)
                }
                
                Section(header: Text("Photos")) {
                    Text("Photos")
                        .frame(height: 100)
                }
            }
            .navigationTitle("New Project")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveProject()
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
*/
/*struct ProjectFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var patternNotes = ""
    @State private var status = "In Progress"
    @State private var currentRow: Int32 = 1
    /*@State private var yarns = UUID(uuid: Yarn)*/
    
    let statuses = ["Not Started", "In Progress", "Completed", "Frogged"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Project Details")) {
                    TextField("Project Name", text: $name)
                    Picker("Status", selection: $status) {
                        ForEach(statuses, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Current Row", value: $currentRow, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Pattern Notes")) {
                    TextEditor(text: $patternNotes)
                        .frame(height: 100)
                }
                
                Section(header: Text("Yarns")) {
                    Text("Yarns")
                        .frame(height: 100)
                }
                
                Section(header: Text("Photos")) {
                    Text("Photos")
                        .frame(height: 100)
                }
            }
            
            .navigationTitle("New Project")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProject()
                    }
                    .disabled(name.isEmpty)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveProject() {
        let project = Project(context: viewContext)
        project.id = UUID()
        project.name = name
        project.patternNotes = patternNotes
        project.status = status
        project.currentRow = currentRow
        //project.yarns = yarns
        project.startDate = Date()
        project.lastModified = Date()
//        project.deleted = false
        
        try? viewContext.save()
        dismiss()
    }
}*/
