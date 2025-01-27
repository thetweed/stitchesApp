//
//  YarnInventoryViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/24/25.
//

import SwiftUI
import CoreData

class YarnInventoryViewModel: ObservableObject {
    @Published var showingAddYarn = false
    let viewContext: NSManagedObjectContext
    
    var yarns: FetchRequest<Yarn>
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.yarns = FetchRequest(
            entity: Yarn.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Yarn.colorName, ascending: true)],
            predicate: NSPredicate(format: "deleted == NO")
        )
    }
    
    func toggleAddProject() {
        showingAddYarn.toggle()
    }
}
