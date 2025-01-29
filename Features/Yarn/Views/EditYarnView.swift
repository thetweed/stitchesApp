//
//  EditYarnView.swift
//  stitchesApp
//
//  Created by Laurie on 1/23/25.
//

import SwiftUI
import CoreData

struct EditYarnView: View {
    @ObservedObject var viewModel: EditYarnViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var yardageString: String = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        Form {
            yarnDetailsSection
            measurementsSection
            propertiesSection
        }
        .navigationTitle("Edit Yarn")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    save()
                }
                .disabled(!viewModel.isFormValid)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            yardageString = String(format: "%.1f", viewModel.totalYardage)
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
            TextField("Total Yardage", text: $yardageString)
                .keyboardType(.decimalPad)
                .onChange(of: yardageString) { oldValue, newValue in
                    if let yards = Double(newValue) {
                        viewModel.totalYardage = yards
                    }
                }
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
            try viewModel.saveChanges()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
    }
}
