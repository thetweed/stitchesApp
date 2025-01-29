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
    private let viewContext: NSManagedObjectContext
    
    init(selectedYarns: Set<Yarn>, viewContext: NSManagedObjectContext) {
        self.selectedYarns = selectedYarns
        self.viewContext = viewContext
    }
    
    func yarnFetchRequest() -> NSFetchRequest<Yarn> {
        let request: NSFetchRequest<Yarn> = Yarn.fetchRequest() as! NSFetchRequest<Yarn>
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Yarn.brand, ascending: true),
            NSSortDescriptor(keyPath: \Yarn.colorName, ascending: true)
        ]
        return request
    }
    
    func toggleSelection(for yarn: Yarn) {
        if selectedYarns.contains(yarn) {
            selectedYarns.remove(yarn)
        } else {
            selectedYarns.insert(yarn)
        }
    }
    
    func isSelected(_ yarn: Yarn) -> Bool {
        selectedYarns.contains(yarn)
    }
}

