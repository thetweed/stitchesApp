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
        NavigationView {
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

/*struct ProjectEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var project: Project
    
    @State private var name: String
    @State private var patternNotes: String
    @State private var status: String
    @State private var currentRow: Int32
    @State private var yarns: Set<Yarn>
    
    let statuses = ["Not Started", "In Progress", "Completed", "Frogged"]
    
    init(project: Project) {
        self.project = project
        _name = State(initialValue: project.name)
        _patternNotes = State(initialValue: project.patternNotes ?? "")
        _status = State(initialValue: project.status)
        _currentRow = State(initialValue: project.currentRow)
        _yarns = State(initialValue: project.yarns ?? Set<Yarn>())
    }
    
    var body: some View {
        NavigationView {
            ProjectEditFormView(project: project)
            .navigationTitle("Edit Project")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        updateProject()
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
    
    func updateProject() {
        project.name = name
        project.patternNotes = patternNotes
        project.status = status
        project.currentRow = currentRow
        project.yarns = yarns
        project.lastModified = Date()
        
        try? viewContext.save()
        dismiss()
    }
}

struct ProjectEditFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var project: Project
    
    @State private var name: String
    @State private var patternNotes: String
    @State private var status: String
    @State private var currentRow: Int32
    @State private var yarns: Set<Yarn>
    
    let statuses = ["Not Started", "In Progress", "Completed", "Frogged"]
    
    init(project: Project) {
        self.project = project
        _name = State(initialValue: project.name)
        _patternNotes = State(initialValue: project.patternNotes ?? "")
        _status = State(initialValue: project.status)
        _currentRow = State(initialValue: project.currentRow)
        _yarns = State(initialValue: project.yarns ?? Set<Yarn>())
    }
    
    private var sortedYarns: [Yarn] {
        Array(yarns).sorted { ($0.colorName) < ($1.colorName) }
    }
    
    private var yarnNavigationLabel: some View {
            HStack {
                Text("Select Yarns")
                Spacer()
                Text("\(yarns.count) selected")
                    .foregroundColor(.gray)
            }
        }
    
    var body: some View {
        Form {
            Section(header: Text("Project Details")) {
                TextField("Project Name", text: $name)
                Picker("Status", selection: $status) {
                    ForEach(statuses, id: \.self) { status in
                        Text(status)
                    }
                }
                TextField("Current Row", value: $currentRow, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("Pattern Notes")) {
                TextEditor(text: $patternNotes)
                    .frame(height: 100)
            }
            
            Section {
                            NavigationLink(
                                destination: YarnSelectionView(selectedYarns: $yarns),
                                label: { yarnNavigationLabel }
                            )
                            
                            ForEach(sortedYarns, id: \.objectID) { yarn in
                                Text(yarn.colorName)
                            }
                        }
        }
    }
}
 */

//#Preview {
//    ProjectEditView(project: <#Project#>)
//}
