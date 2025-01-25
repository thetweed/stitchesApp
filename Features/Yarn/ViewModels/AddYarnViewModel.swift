//
//  AddYarnViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/23/25.
//

import SwiftUI
import CoreData

class AddYarnViewModel: ObservableObject {
   @Published var brand = ""
   @Published var colorName = ""
   @Published var weightCategory = ""
   @Published var fiberContent = ""
   @Published var totalYardage = ""
   private let context: NSManagedObjectContext
   
   init(viewContext: NSManagedObjectContext) {
       self.context = viewContext
   }
   
   var isFormValid: Bool {
       !brand.isEmpty &&
       !colorName.isEmpty &&
       !weightCategory.isEmpty &&
       !fiberContent.isEmpty &&
       Double(totalYardage) != nil
   }
   
   func saveYarn() throws {
       guard let yardage = Double(totalYardage) else {
           throw ValidationError.invalidYardage
       }
       
       let yarn = Yarn.create(
           in: context,
           brand: brand,
           colorName: colorName,
           weightCategory: weightCategory,
           fiberContent: fiberContent,
           totalYardage: yardage
       )
       
       try context.save()
   }
   
   enum ValidationError: Error {
       case invalidYardage
   }
}
