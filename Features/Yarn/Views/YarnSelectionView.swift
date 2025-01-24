//
//  YarnSelectionView.swift
//  stitchesApp
//
//  Created by Laurie on 1/22/25.
//

import SwiftUI
import CoreData

struct YarnSelectionView: View {
    @StateObject private var viewModel: YarnSelectionViewModel
    @Binding var selectedYarns: Set<Yarn>
    @FetchRequest private var yarns: FetchedResults<Yarn>
    
    init(selectedYarns: Binding<Set<Yarn>>, viewContext: NSManagedObjectContext) {
        let vm = YarnSelectionViewModel(selectedYarns: selectedYarns.wrappedValue, viewContext: viewContext)
        _viewModel = StateObject(wrappedValue: vm)
        _yarns = FetchRequest<Yarn>(fetchRequest: vm.fetchYarns())
        _selectedYarns = selectedYarns
    }
    
    var body: some View {
        List {
            ForEach(yarns, id: \.id) { yarn in
                HStack{
                    Text(yarn.colorName)
                    Spacer()
                    if viewModel.selectedYarns.contains(yarn) {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.toggleSelection(for: yarn)
                }
            }
        }
    }
}

/*
struct YarnSelectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectedYarns: Set<Yarn>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Yarn.colorName, ascending: true)],
        animation: .default)
    private var yarns: FetchedResults<Yarn>
    
    var body: some View {
        List {
            ForEach(yarns, id: \.objectID) { yarn in
                HStack {
                    Text(yarn.colorName)
                    Spacer()
                    if selectedYarns.contains(yarn) {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedYarns.contains(yarn) {
                        selectedYarns.remove(yarn)
                    } else {
                        selectedYarns.insert(yarn)
                    }
                }
            }
        }
        .navigationTitle("Select Yarns")
    }
}
 */

//#Preview {
  //  YarnSelectionView()
//}

