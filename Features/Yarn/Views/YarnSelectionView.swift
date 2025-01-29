//
//  YarnSelectionView.swift
//  stitchesApp
//
//  Created by Laurie on 1/22/25.
//

import SwiftUI
import CoreData

/*struct YarnSelectionView: View {
   @Environment(\.dismiss) private var dismiss
   @StateObject private var viewModel: YarnSelectionViewModel
   @Binding var selectedYarns: Set<Yarn>
   @FetchRequest private var yarns: FetchedResults<Yarn>
   
   init(selectedYarns: Binding<Set<Yarn>>, viewContext: NSManagedObjectContext) {
       let vm = YarnSelectionViewModel(selectedYarns: selectedYarns.wrappedValue, viewContext: viewContext)
       _viewModel = StateObject(wrappedValue: vm)
       _yarns = FetchRequest<Yarn>(fetchRequest: vm.yarnFetchRequest())
       _selectedYarns = selectedYarns
   }
   
   var body: some View {
       NavigationStack {
           List {
               if yarns.isEmpty {
                   emptyStateView
               } else {
                   yarnList
               }
           }
           .navigationTitle("Select Yarns")
           .navigationBarTitleDisplayMode(.inline)
           .toolbar {
               ToolbarItem(placement: .navigationBarTrailing) {
                   Button("Done") {
                       selectedYarns = viewModel.selectedYarns
                       dismiss()
                   }
               }
               ToolbarItem(placement: .navigationBarLeading) {
                   Button("Cancel", role: .cancel) {
                       dismiss()
                   }
               }
           }
       }
   }
   
   private var yarnList: some View {
       ForEach(yarns, id: \.safeID) { yarn in
           YarnSelectionRow(
               yarn: yarn,
               isSelected: viewModel.isSelected(yarn),
               onTap: {
                   viewModel.toggleSelection(for: yarn)
                   selectedYarns = viewModel.selectedYarns
               }
           )
       }
   }
   
   private var emptyStateView: some View {
       VStack(spacing: 20) {
           Image(systemName: "scalemass.fill")
               .font(.system(size: 60))
               .foregroundColor(.secondary)
           
           Text("No Yarns Available")
               .font(.title2)
               .foregroundColor(.primary)
           
           Text("Add yarns to your inventory first")
               .font(.subheadline)
               .foregroundColor(.secondary)
               .multilineTextAlignment(.center)
               .padding(.horizontal)
       }
       .padding()
       .frame(maxWidth: .infinity, maxHeight: .infinity)
       .background(Color(.systemGroupedBackground))
       .listRowInsets(EdgeInsets())
   }
}

struct YarnSelectionRow: View {
   let yarn: Yarn
   let isSelected: Bool
   let onTap: () -> Void
   
   var body: some View {
       HStack {
           YarnRowView(yarn: yarn, showDetails: false)
           Spacer()
           if isSelected {
               Image(systemName: "checkmark.circle.fill")
                   .foregroundColor(.accentColor)
                   .imageScale(.large)
           }
       }
       .contentShape(Rectangle())
       .onTapGesture(perform: onTap)
       .listRowBackground(isSelected ? Color.accentColor.opacity(0.1) : nil)
   }
}

struct YarnSelectionRowOriginalDesign: View {
    let yarn: Yarn
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            YarnRowView(yarn: yarn)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .imageScale(.large)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}*/

struct YarnSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: YarnSelectionViewModel
    @Binding var selectedYarns: Set<Yarn>
    @FetchRequest private var yarns: FetchedResults<Yarn>
    
    init(selectedYarns: Binding<Set<Yarn>>, viewContext: NSManagedObjectContext) {
        let vm = YarnSelectionViewModel(selectedYarns: selectedYarns.wrappedValue, viewContext: viewContext)
        _viewModel = StateObject(wrappedValue: vm)
        _yarns = FetchRequest<Yarn>(fetchRequest: vm.yarnFetchRequest())
        _selectedYarns = selectedYarns
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    if !availableYarns.isEmpty {
                        yarnSection(
                            title: "Available Yarns",
                            systemImage: "circle.hexagongrid.fill",
                            yarns: availableYarns,
                            accentColor: .green
                        )
                    }
                    
                    if !inUseYarns.isEmpty {
                        yarnSection(
                            title: "In Other Projects",
                            systemImage: "knot",
                            yarns: inUseYarns,
                            accentColor: .blue
                        )
                    }
                    
                    if yarns.isEmpty {
                        emptyStateView
                    }
                }
                .padding()
            }
            .navigationTitle("Select Yarns")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        selectedYarns = viewModel.selectedYarns
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var availableYarns: [Yarn] {
        yarns.filter { $0.projectsArray.isEmpty }
    }
    
    private var inUseYarns: [Yarn] {
        yarns.filter { !$0.projectsArray.isEmpty }
    }
    
    private func yarnSection(title: String, systemImage: String, yarns: [Yarn], accentColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(accentColor)
                .padding(.leading, 4)
            
            VStack(spacing: 12) {
                ForEach(yarns, id: \.safeID) { yarn in
                    YarnSelectionRow(
                        yarn: yarn,
                        isSelected: viewModel.isSelected(yarn),
                        onTap: {
                            viewModel.toggleSelection(for: yarn)
                            selectedYarns = viewModel.selectedYarns
                        }
                    )
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "circle.hexagongrid.fill")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text("No Yarns Available")
                .font(.headline)
            
            Text("Add yarns to your inventory first")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

struct YarnSelectionRow: View {
    let yarn: Yarn
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            YarnRowView(yarn: yarn, showDetails: false)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
            
            Spacer()
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .accentColor : .secondary)
                .imageScale(.large)
                .padding(.trailing, 8)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.accentColor : .clear, lineWidth: 2)
                )
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

struct YarnSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager.shared.container.viewContext
        let previewData = PreviewingData()
        let sampleYarns = previewData.sampleYarns(context)
        
        NavigationStack {
            YarnSelectionView(
                selectedYarns: .constant(Set(sampleYarns.prefix(2))),
                viewContext: context
            )
        }
        .environment(\.managedObjectContext, context)
    }
}
