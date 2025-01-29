//
//  YarnRepository.swift
//  stitchesApp
//
//  Created by Laurie on 1/14/25.
//

import SwiftUI
import CoreData

/* class YarnRepository: Identifiable {
    
    let viewContext: NSManagedObjectContext
    
    // Initialize the class
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    // Save check
    private func save() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
        
    // Add yarn (Create)
    func createYarn(brand: String,
                    colorName: String,
                    weightCategory: String,
                    fiberContent: String,
                    totalYardage: Double) -> Yarn {
        let yarn = Yarn.create(in: viewContext,
                                brand: brand,
                                colorName: colorName,
                                weightCategory: weightCategory,
                                fiberContent: fiberContent,
                                totalYardage: totalYardage)
        save()
        return yarn
    }
        
    // Read
    func fetchYarns() -> [Yarn] {
        let request = NSFetchRequest<Yarn>(entityName: "Yarn")
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching projects: \(error)")
        }
        return []
    }
        
    // Update project, update date last modified
    func updateYarn(_ project: Yarn) {
        save()
    }
        
    // Delete
    func deleteYarn(_ yarn: Yarn) {
        viewContext.delete(yarn)
        save()
    }
}

*/
