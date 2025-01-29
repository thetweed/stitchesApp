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
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                yarnDetailsSection
                measurementsSection
                propertiesSection
            }
            .navigationTitle("Add Yarn")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(!viewModel.isFormValid)
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private var yarnDetailsSection: some View {
        Section("Yarn Details") {
            TextField("Brand", text: $viewModel.brand)
                .textInputAutocapitalization(.words)
            TextField("Color Name", text: $viewModel.colorName)
                .textInputAutocapitalization(.words)
            TextField("Color Number", text: $viewModel.colorNumber)
        }
    }
    
    private var measurementsSection: some View {
        Section("Measurements") {
            TextField("Total Yardage", text: $viewModel.totalYardage)
                .keyboardType(.decimalPad)
        }
    }
    
    private var propertiesSection: some View {
        Section("Properties") {
            Picker("Weight Category", selection: $viewModel.weightCategory) {
                ForEach(Yarn.weightCategories, id: \.self) {
                    Text($0)
                }
            }
            TextField("Fiber Content", text: $viewModel.fiberContent)
                .textInputAutocapitalization(.words)
        }
    }
    
    private func save() {
        do {
            try viewModel.saveYarn()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
    }
}
