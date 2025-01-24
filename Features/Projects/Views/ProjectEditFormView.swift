//
//  ProjectEditFormView.swift
//  stitchesApp
//
//  Created by Laurie on 1/23/25.
//

import SwiftUI
import CoreData

struct ProjectEditFormView: View {
    @ObservedObject var viewModel: ProjectEditViewModel
    @Environment(\.managedObjectContext) var viewContext
    
    private var yarnNavigationLabel: some View {
        HStack {
            Text("Select Yarns")
            Spacer()
            Text("\(viewModel.yarns.count) selected")
                .foregroundColor(.gray)
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Project Details")) {
                TextField("Project Name", text: $viewModel.name)
                Picker("Status", selection: $viewModel.status) {
                    ForEach(viewModel.statuses, id: \.self) { status in
                        Text(status)
                    }
                }
                TextField("Current Row", value: $viewModel.currentRow, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("Pattern Notes")) {
                TextEditor(text: $viewModel.patternNotes)
                    .frame(height: 100)
            }
            
            Section {
                NavigationLink(
                    destination: YarnSelectionView(selectedYarns: $viewModel.yarns, viewContext: viewContext),
                    label: { yarnNavigationLabel }
                )
                
                ForEach(viewModel.sortedYarns, id: \.objectID) { yarn in
                    Text(yarn.colorName)
                }
            }
        }
    }
}
