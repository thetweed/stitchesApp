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
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func yarnFetchRequest() -> NSFetchRequest<Yarn> {
        let request: NSFetchRequest<Yarn> = Yarn.fetchRequest() as! NSFetchRequest<Yarn>
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Yarn.brand, ascending: true),
            NSSortDescriptor(keyPath: \Yarn.colorName, ascending: true)
        ]
        request.predicate = NSPredicate(format: "deleted == NO")
        return request
    }
    
    func toggleAddYarn() {
        showingAddYarn.toggle()
    }
}

