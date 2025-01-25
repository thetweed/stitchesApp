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
                HStack {
                    Text(yarn.colorName)
                    Spacer()
                    if viewModel.selectedYarns.contains(yarn) {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.toggleSelection(for: yarn)
                    selectedYarns = viewModel.selectedYarns
                }
            }
        }
    }
}

struct YarnSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager.shared.container.viewContext
        let previewData = PreviewingData()
        let sampleYarns = previewData.sampleYarns(context)
        
        NavigationView {
            YarnSelectionView(
                selectedYarns: .constant(Set(sampleYarns.prefix(2))),
                viewContext: context
            )
        }
        .environment(\.managedObjectContext, context)
    }
}
