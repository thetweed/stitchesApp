//
//  TestYarnListView.swift
//  stitchesApp
//
//  Created by Laurie on 1/27/25.
//

import SwiftUI
import CoreData

struct YarnListTestView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var yarns: FetchedResults<Yarn>
    
    init() {
        _yarns = FetchRequest<Yarn>(
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Yarn.brand, ascending: true),
                NSSortDescriptor(keyPath: \Yarn.colorName, ascending: true)
            ],
            predicate: NSPredicate(format: "deleted == NO"),
            animation: .default
        )
    }
    
    var body: some View {
        List {
            if yarns.isEmpty {
                emptyStateView
            } else {
                yarnsList
            }
        }
        .navigationTitle("Yarn Test View")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var yarnsList: some View {
        ForEach(yarns, id: \.safeID) { yarn in
            YarnTestRow(yarn: yarn)
        }
    }
    
    private var emptyStateView: some View {
        Text("No yarns found")
            .font(.callout)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(Color.clear)
    }
}

struct YarnTestRow: View {
    let yarn: Yarn
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Group {
                yarnBasicInfo
                yarnDetails
                if !yarn.projectsArray.isEmpty {
                    projectsInfo
                }
            }
            .font(.subheadline)
        }
        .padding(.vertical, 8)
    }
    
    private var yarnBasicInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(yarn.brand)
                .font(.headline)
            
            Text(yarn.colorName)
                .foregroundColor(.secondary)
            
            if let colorNumber = yarn.colorNumber {
                Text("Color #: \(colorNumber)")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var yardDetails: some View {
        HStack {
            Text("Total: \(String(format: "%.1f", yarn.totalYardage))y")
            Text("Used: \(String(format: "%.1f", yarn.usedYardage))y")
            Text("Remaining: \(String(format: "%.1f", yarn.remainingYardage))y")
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }
    
    private var yarnDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Weight: \(yarn.weightCategory)")
            
            if let fiberContent = yarn.fiberContent {
                Text("Fiber: \(fiberContent)")
            }
            
            yardDetails
        }
    }
    
    private var projectsInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Projects:")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ForEach(yarn.projectsArray) { project in
                Text("• \(project.name)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}


#Preview {
    NavigationStack {
        YarnListTestView()
            .environment(\.managedObjectContext, CoreDataManager.shared.container.viewContext)
    }
}

