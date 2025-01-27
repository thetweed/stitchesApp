//
//  YarnInventoryView\.swift
//  stitchesApp
//
//  Created by Laurie on 1/24/25.
//

import SwiftUI
import CoreData

struct YarnInventoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: YarnInventoryViewModel
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Yarn.colorName, ascending: true)],
        predicate: NSPredicate(format: "deleted == NO"),
        animation: .default
    ) private var yarns: FetchedResults<Yarn>
    
    init(viewContext: NSManagedObjectContext) {
        let vm = YarnInventoryViewModel(viewContext: viewContext)
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(yarns, id: \.safeID) { yarn in
                    NavigationLink(value: yarn.safeID) {
                        YarnRowView(yarn: yarn)
                    }
                }
                .onDelete(perform: deleteYarn)
            }
            .navigationTitle("Yarn Inventory")
            .navigationDestination(for: NSManagedObjectID.self) { yarnID in
                if let yarn = try? viewContext.existingObject(with: yarnID) as? Yarn {
                    YarnDetailView(yarn: yarn)
                        .environment(\.managedObjectContext, viewContext)
                }
            }
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
        .environment(\.managedObjectContext, viewContext)
    }
    
    private func deleteYarn(at offsets: IndexSet) {
        viewContext.performAndWait {
            for index in offsets {
                let yarn = yarns[index]
                viewContext.delete(yarn)
            }
            try? viewContext.save()
        }
    }
}



#Preview {
    Previewing(\.sampleYarns) { _ in
        YarnInventoryView(viewContext: CoreDataManager.shared.container.viewContext)
    }
}
