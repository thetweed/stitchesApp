//
//  CounterSetupView.swift
//  stitchesApp
//
//  Created by Laurie on 1/28/25.
//

import SwiftUI
import CoreData

/*struct CounterSetupView: View {
    @Environment(\.managedObjectContext) private var context
        @Environment(\.dismiss) private var dismiss
        
        var project: Project?  // Make this optional
        
        @State private var counterName: String = ""
        @State private var selectedCounterType: String = Counter.counterTypes[0]
        @State private var targetCount: String = ""
        @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Counter Details")) {
                    TextField("Counter Name", text: $counterName)
                    
                    Picker("Counter Type", selection: $selectedCounterType) {
                        ForEach(Counter.counterTypes, id: \.self) { type in
                            Text(type.capitalized)
                                .tag(type)
                        }
                    }
                    
                    TextField("Target Count", text: $targetCount)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("New Counter")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCounter()
                    }
                    .disabled(counterName.isEmpty)
                }
            }
        }
    }
    
    private func saveCounter() {
        let counter = Counter(context: context)
        counter.id = UUID()
        counter.name = counterName
        counter.counterType = selectedCounterType
        counter.currentCount = 0
        counter.targetCount = Int32(targetCount) ?? 0
        counter.notes = notes
        counter.lastModified = Date()
        counter.project = project  // This will be nil if no project is associated
        
        do {
            try context.save()
            dismiss()
        } catch {
            print("Error saving counter: \(error)")
        }
    }
}
*/
