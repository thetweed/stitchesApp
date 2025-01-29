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
    @FetchRequest private var yarns: FetchedResults<Yarn>
    
    init(viewContext: NSManagedObjectContext) {
        let vm = YarnInventoryViewModel(viewContext: viewContext)
        _viewModel = StateObject(wrappedValue: vm)
        _yarns = FetchRequest(fetchRequest: vm.yarnFetchRequest())
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    if !inUseYarns.isEmpty {
                        yarnSection(
                            title: "In Projects",
                            systemImage: "knot",
                            yarns: inUseYarns,
                            accentColor: .blue
                        )
                    }
                    
                    if !availableYarns.isEmpty {
                        yarnSection(
                            title: "Available",
                            systemImage: "circle.hexagongrid.fill",
                            yarns: availableYarns,
                            accentColor: .green
                        )
                    }
                    
                    if yarns.isEmpty {
                        emptyStateView
                    }
                }
                .padding()
            }
            .navigationTitle("Yarn Inventory")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.toggleAddYarn()
                    } label: {
                        Label("Add Yarn", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddYarn) {
                NavigationStack {
                    AddYarnView(viewModel: AddYarnViewModel(viewContext: viewContext))
                }
            }
        }
    }
    
    private var inUseYarns: [Yarn] {
        yarns.filter { !$0.projectsArray.isEmpty }
    }
    
    private var availableYarns: [Yarn] {
        yarns.filter { $0.projectsArray.isEmpty }
    }
    
    private func yarnSection(title: String, systemImage: String, yarns: [Yarn], accentColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(accentColor)
                .padding(.leading, 4)
            
            VStack(spacing: 12) {
                ForEach(yarns, id: \.safeID) { yarn in
                    NavigationLink(destination: YarnDetailView(yarn: yarn)) {
                        YarnRowView(yarn: yarn)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                            )
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "circle.hexagongrid.fill")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text("No Yarn Yet")
                .font(.headline)
            
            Text("Tap the + button to add your first yarn")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

#Preview {
    Previewing(\.sampleYarns) { _ in
        YarnInventoryView(viewContext: CoreDataManager.shared.container.viewContext)
    }
}
