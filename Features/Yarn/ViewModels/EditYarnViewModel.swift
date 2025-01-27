//
//  EditYarnViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/23/25.
//

import SwiftUI
import CoreData

class EditYarnViewModel: ObservableObject {
    @Published var brand: String = ""
    @Published var colorName: String = ""
    @Published var weightCategory: String = ""
    @Published var fiberContent: String = ""
    @Published var totalYardage: Double = 0.0
    let yarn: Yarn
   private let context: NSManagedObjectContext
   
   init(yarn: Yarn) {
       self.yarn = yarn
       self.context = yarn.managedObjectContext ?? CoreDataManager.shared.container.viewContext
       self.brand = yarn.brand
       self.colorName = yarn.colorName
       self.weightCategory = yarn.weightCategory
       self.fiberContent = yarn.fiberContent ?? ""
       self.totalYardage = yarn.totalYardage
   }
   
   var isFormValid: Bool {
       !brand.isEmpty &&
       !colorName.isEmpty &&
       !weightCategory.isEmpty &&
       !fiberContent.isEmpty &&
       totalYardage > 0
   }
   
   /*func saveChanges() throws {
       guard totalYardage > 0 else {
           throw ValidationError.invalidYardage
       }
       
       yarn.brand = brand
       yarn.colorName = colorName
       yarn.weightCategory = weightCategory
       yarn.fiberContent = fiberContent
       yarn.totalYardage = totalYardage
       
       try context.save()
   }*/
   
    func saveChanges() throws {
        guard totalYardage >= 0 else {
            throw ValidationError.invalidYardage
        }
        yarn.brand = brand
        yarn.colorName = colorName
        yarn.weightCategory = weightCategory
        yarn.fiberContent = fiberContent
        yarn.totalYardage = totalYardage
        
        // Save context
        do {
            try context.save()
            // Post notification after successful save
            NotificationCenter.default.post(
                name: NSNotification.Name("YarnDidUpdate"),
                object: nil,
                userInfo: ["yarnID": yarn.objectID]
            )
        } catch {
            print("Error saving context: \(error)")
            throw error
        }
    }
    
   enum ValidationError: Error {
       case invalidYardage
   }
}
