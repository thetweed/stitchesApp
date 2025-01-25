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
    
    init(yarn: Yarn) {
        _viewModel = StateObject(wrappedValue: YarnDetailViewModel(yarn: yarn))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                yarnHeader
                yarnDetails
                fiberContentSection
                projectsSection
                
                if let photoData = viewModel.yarn.photoData,
                   let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.yarn.colorName)
        .toolbar {
            Button("Edit") {
                viewModel.showingEditSheet.toggle()
            }
        }
        .sheet(isPresented: $viewModel.showingEditSheet) {
            // Replace with your actual YarnEditView when available
            Text("Yarn Edit View Placeholder")
        }
    }
    
    private var yarnHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.brandText)
                .font(.headline)
            Text(viewModel.colorDetails)
                .font(.subheadline)
            Text(viewModel.weightCategoryText)
                .font(.subheadline)
            Text(viewModel.purchaseDateText)
                .font(.subheadline)
        }
    }
    
    private var yarnDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.yardageText)
                .font(.headline)
        }
    }
    
    private var fiberContentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Fiber Content")
                .font(.headline)
            Text(viewModel.fiberContentText)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    private var projectsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Projects")
                .font(.headline)
            if viewModel.hasProjects {
                ForEach(viewModel.projects, id: \.self) { project in
                    Text(project.name)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            } else {
                Text("No projects using this yarn")
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
}

struct YarnDetailView_Previews: PreviewProvider {
    static let context = CoreDataManager.shared.container.viewContext
    
    static var previews: some View {
        let sampleData = PreviewingData()
        let yarns = sampleData.sampleYarns(context)
        return YarnDetailView(yarn: yarns[0])
            .environment(\.managedObjectContext, context)
    }
}
