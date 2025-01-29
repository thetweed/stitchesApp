//
//  YarnDetailView.swift
//  stitchesApp
//
//  Created by Laurie on 1/25/25.
//

import SwiftUI
import CoreData

struct YarnDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: YarnDetailViewModel
    @ObservedObject var yarn: Yarn
    
    init(yarn: Yarn) {
        self.yarn = yarn
        _viewModel = StateObject(wrappedValue: YarnDetailViewModel(yarn: yarn))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                yarnHeader
                yarnDetails
                fiberContentSection
                projectsSection
                
                if let photoData = yarn.photoData,
                   let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                }
            }
            .padding()
        }
        .navigationTitle(yarn.colorName)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.showingEditSheet.toggle()
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
            }
        }
        .sheet(isPresented: $viewModel.showingEditSheet) {
            NavigationStack {
                EditYarnView(viewModel: EditYarnViewModel(yarn: yarn))
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    private var yarnHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.brandText)
                .font(.headline)
            Text(viewModel.colorDetails)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(viewModel.weightCategoryText)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(viewModel.purchaseDateText)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private var yarnDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.yardageText)
                .font(.headline)
                .padding(.vertical, 4)
        }
    }
    
    private var fiberContentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Fiber Content", systemImage: "list.bullet")
                .font(.headline)
            Text(viewModel.yarn.fiberContent ?? "Not specified")
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    private var projectsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Projects", systemImage: "folder")
                .font(.headline)
            
            if viewModel.hasProjects {
                projectsList
            } else {
                Text("No projects using this yarn")
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
    
    private var projectsList: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.projectsArray) { project in
                NavigationLink(destination: ProjectDetailView(project: project)) {
                    ProjectRowView(project: project)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
    }
}

extension YarnDetailView {
    private func loadImage() -> UIImage? {
        guard let photoData = yarn.photoData else { return nil }
        return UIImage(data: photoData)
    }
}

struct YarnDetailView_Previews: PreviewProvider {
    static let context = CoreDataManager.shared.container.viewContext
    
    static var previews: some View {
        let sampleData = PreviewingData()
        let yarns = sampleData.sampleYarns(context)
        
        Group {
            NavigationStack {
                YarnDetailView(yarn: yarns[0])
                    .environment(\.managedObjectContext, context)
            }
            
            YarnInventoryView(viewContext: context)
                .environment(\.managedObjectContext, context)
        }
    }
}

extension YarnDetailView_Previews {
    static var inventoryPreview: some View {
        YarnInventoryView(viewContext: context)
            .environment(\.managedObjectContext, context)
    }
}

