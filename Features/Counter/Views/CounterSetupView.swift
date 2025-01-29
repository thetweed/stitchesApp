//
//  CounterSetupView.swift
//  stitchesApp
//
//  Created by Laurie on 1/28/25.
//

import SwiftUI
import CoreData

struct CounterSetupView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: CounterSetupViewModel
    
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.name, ascending: true)],
        animation: .default
    ) var projects: FetchedResults<Project>
    
    init(project: Project? = nil) {
        _viewModel = StateObject(wrappedValue: CounterSetupViewModel(project: project))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Counter Details") {
                    TextField("Counter Name", text: $viewModel.counterName)
                    
                    Picker("Counter Type", selection: $viewModel.counterType) {
                        ForEach(Counter.counterTypes, id: \.self) { type in
                            Text(type.capitalized)
                                .tag(type)
                        }
                    }
                    
                    TextField("Target Count", value: $viewModel.targetCount, format: .number)
                        .keyboardType(.numberPad)
                }
                
                Section("Project") {
                    Picker("Attach to Project", selection: $viewModel.selectedProject) {
                        Text("None")
                            .tag(Optional<Project>.none)
                        
                        ForEach(projects) { project in
                            Text(project.name)
                                .tag(Optional(project))
                        }
                    }
                }
                
                Section("Additional Settings") {
                    TextField("Starting Count", value: $viewModel.startingCount, format: .number)
                        .keyboardType(.numberPad)
                    
                    if viewModel.counterType == "repeat" {
                        TextField("Stitches per Repeat", value: $viewModel.stitchesPerRepeat, format: .number)
                            .keyboardType(.numberPad)
                    }
                }
                
                Section("Notes") {
                    TextEditor(text: $viewModel.notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("New Counter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.saveCounter(context: context)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CounterSetupView_Previews: PreviewProvider {
    static var previews: some View {
        Previewing(\.sampleProjectWithCounter) { project in
            CounterSetupView(project: project)
        }
        
        Previewing(\.sampleProjectWithCounter) { _ in
            CounterSetupView(project: nil)
        }
        .previewDisplayName("No Project")
    }
}
