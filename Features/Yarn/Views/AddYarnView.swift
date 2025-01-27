//
//  AddYarnView.swift
//  stitchesApp
//
//  Created by Laurie on 1/23/25.
//

import SwiftUI
import CoreData

struct AddYarnView: View {
    @StateObject var viewModel: AddYarnViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: AddYarnViewModel) {
         _viewModel = StateObject(wrappedValue: viewModel)
     }
    
    let context = CoreDataManager.shared.container.viewContext
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Brand", text: $viewModel.brand)
                    TextField("Color Name", text: $viewModel.colorName)
                    TextField("Weight Category", text: $viewModel.weightCategory)
                    TextField("Fiber Content", text: $viewModel.fiberContent)
                    TextField("Total Yardage", text: $viewModel.totalYardage)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Button("Save") {
                        do {
                            try viewModel.saveYarn()
                            dismiss()
                        } catch {
                            print("Error saving yarn: \(error)")
                        }
                    }
                }
                .navigationTitle("Add Yarn")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
}
