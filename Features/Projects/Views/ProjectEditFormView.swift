//
//  ProjectEditFormView.swift
//  stitchesApp
//
//  Created by Laurie on 1/23/25.
//

import SwiftUI
import CoreData

/*struct ProjectEditFormView: View {
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
*/

struct ProjectEditFormView: View {
    @ObservedObject var viewModel: ProjectAddEditViewModel
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
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
            
            ForEach(viewModel.sortedYarns) { yarn in
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

/*struct ProjectEditFormView_Previews: PreviewProvider {
   static var previews: some View {
       NavigationView {
           Previewing(\.sampleProjects) { projects in
               ProjectEditFormView(
                   viewModel: ProjectAddEditViewModel(
                       project: projects[0],
                       viewContext: CoreDataManager.shared.container.viewContext
                   )
               )
           }
       }
   }
}
*/
