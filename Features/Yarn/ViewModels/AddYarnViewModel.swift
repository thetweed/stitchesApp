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
    @Published var colorNumber = ""
    @Published var weightCategory = Yarn.WeightCategory.worsted.rawValue
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
        Double(totalYardage) != nil && Double(totalYardage)! > 0
    }
    
    func saveYarn() throws {
        guard let yardage = Double(totalYardage), yardage > 0 else {
            throw ValidationError.invalidYardage
        }
        
        context.performAndWait {
            let yarn = Yarn.create(
                in: context,
                brand: brand,
                colorName: colorName,
                weightCategory: weightCategory,
                fiberContent: fiberContent,
                totalYardage: yardage
            )
            
            yarn.colorNumber = colorNumber.isEmpty ? nil : colorNumber
            
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    enum ValidationError: Error {
        case invalidYardage
        
        var localizedDescription: String {
            switch self {
            case .invalidYardage:
                return "Please enter a valid yardage greater than 0"
            }
        }
    }
}

