//
//  YarnbookView.swift
//  stitchesApp
//
//  Created by Laurie on 1/15/25.
//

import SwiftUI
import CoreData

struct YarnbookView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        YarnInventoryView(viewContext: viewContext)
    }
}

struct YarnbookView_Previews: PreviewProvider {
    static let context = CoreDataManager.shared.container.viewContext
    
    static var previews: some View {
        let sampleData = PreviewingData()
        let _ = sampleData.sampleProjects(context)
        return YarnbookView()
            .environment(\.managedObjectContext, context)
    }
}
