//
//  YarnInventoryView\.swift
//  stitchesApp
//
//  Created by Laurie on 1/24/25.
//

import SwiftUI
import CoreData

struct YarnInventoryView: View {
    @StateObject private var viewModel: YarnInventoryViewModel
    @FetchRequest private var yarns: FetchedResults<Yarn>
    
    init(viewContext: NSManagedObjectContext) {
        let vm = YarnInventoryViewModel(viewContext: viewContext)
        _viewModel = StateObject(wrappedValue: vm)
        _yarns = FetchRequest(fetchRequest: vm.yarnFetchRequest())
    }
    
    var body: some View {
            NavigationView {
                List {
                    ForEach(yarns) { yarn in
                        YarnRowView(yarn: yarn)
                    }
                    .onDelete(perform: deleteYarn)
                }
                .navigationTitle("Yarn Inventory")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: viewModel.toggleAddProject) {
                            Label("New Yarn", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $viewModel.showingAddYarn) {
                    AddYarnView(viewModel: AddYarnViewModel(viewContext: viewModel.viewContext))
                }
            }
        }
        
    private func deleteYarn(at offsets: IndexSet) {
        viewModel.viewContext.performAndWait {
            for index in offsets {
                let yarn = yarns[index]
                viewModel.viewContext.delete(yarn)
            }
            try? viewModel.viewContext.save()
        }
    }
}

#Preview {
    Previewing(\.sampleYarns) { _ in
        YarnInventoryView(viewContext: CoreDataManager.shared.container.viewContext)
    }
}
