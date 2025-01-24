//
//  YarnSelectionViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/23/25.
//

import SwiftUI
import CoreData

class YarnSelectionViewModel: ObservableObject {
    @Published var selectedYarns: Set<Yarn>
    @Published var error: Error?
    private let viewContext: NSManagedObjectContext
    
    init(selectedYarns: Set<Yarn>, viewContext: NSManagedObjectContext) {
        self.selectedYarns = selectedYarns
        self.viewContext = viewContext
    }
    
    func fetchYarns() -> NSFetchRequest<Yarn> {
        let request: NSFetchRequest<Yarn> = Yarn.fetchRequest() as! NSFetchRequest<Yarn>
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Yarn.colorName, ascending: true)]
        return request
    }
    
    func loadYarns() {
        do {
            let _yarns = try viewContext.fetch(fetchYarns())
        } catch {
            self.error = error
        }
    }
    
    func toggleSelection(for yarn: Yarn) {
        if selectedYarns.contains(yarn) {
            selectedYarns.remove(yarn)
        } else {
            selectedYarns.insert(yarn)
        }
    }
}
