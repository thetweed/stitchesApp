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
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Yarn.colorName, ascending: true)],
        animation: .default)
    private var yarns: FetchedResults<Yarn>
    
    var body: some View {
        List {
            ForEach(yarns, id: \.safeID) { yarn in
                VStack(alignment: .leading) {
                    Text("Brand: \(yarn.brand)")
                        .font(.headline)
                    Text("Color: \(yarn.colorName)")
                    Text("Weight: \(yarn.weightCategory)")
                    Text("Yardage: \(String(format: "%.1f", yarn.totalYardage))")
                    if let fiberContent = yarn.fiberContent {
                        Text("Fiber: \(fiberContent)")
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("All Yarns Test View")
    }
}

struct YarnListTestView_Previews: PreviewProvider {
    static let context = CoreDataManager.shared.container.viewContext
    
    static var previews: some View {
        let sampleData = PreviewingData()
        let _ = sampleData.sampleYarns(context)
        
        return NavigationStack {
            YarnListTestView()
                .environment(\.managedObjectContext, context)
        }
    }
}
