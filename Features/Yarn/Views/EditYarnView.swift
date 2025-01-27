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
   
   private func save() {
       do {
           try viewModel.saveChanges()
           dismiss()
       } catch {
           showingError = true
       }
   }
   
   var body: some View {
       Form {
           TextField("Brand", text: $viewModel.brand)
           TextField("Color", text: $viewModel.colorName)
           TextField("Weight Category", text: $viewModel.weightCategory)
           TextField("Fiber Content", text: $viewModel.fiberContent)
           TextField("Total Yardage", text: $yardageString)
               .keyboardType(.decimalPad)
               .onChange(of: yardageString) { oldValue, newValue in
                   if let yards = Double(newValue) {
                       viewModel.totalYardage = yards
                   }
               }
       }
       .navigationTitle("Edit Yarn")
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
       .alert("Invalid Yardage", isPresented: $showingError) {
           Button("OK", role: .cancel) {}
       }
       .onAppear {
           yardageString = String(viewModel.totalYardage)
       }
       .onDisappear {
           if let context = viewModel.yarn.managedObjectContext {
               try? context.save()
           }
       }
   }
}

/*struct EditYarnView: View {
    @StateObject var viewModel: EditYarnViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var yardageString: String = ""
    @State private var showingError = false
    
    var body: some View {
        Form {
            TextField("Brand", text: $viewModel.brand)
            TextField("Color", text: $viewModel.colorName)
            TextField("Weight Category", text: $viewModel.weightCategory)
            TextField("Fiber Content", text: $viewModel.fiberContent)
            TextField("Total Yardage", text: $yardageString)
                .keyboardType(.decimalPad)
                .onChange(of: yardageString) { newValue in
                    if let yards = Double(newValue) {
                        viewModel.totalYardage = yards
                    }
                }
                .navigationTitle("Edit Yarn")
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
                .alert("Invalid Yardage", isPresented: $showingError) {
                    Button("OK", role: .cancel) {}
                }
        }
        
        func save() {
            do {
                try viewModel.saveChanges()
                dismiss()
            } catch {
                showingError = true
            }
        }
    }
}*/
