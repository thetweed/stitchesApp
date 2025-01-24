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
    private var yarnToEdit: Yarn?
    
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
        let context = CoreDataManager.shared.container.viewContext
        let yarn = Yarn(context: context)
        yarn.id = UUID()
        yarn.brand = brand
        yarn.colorName = colorName
        yarn.weightCategory = weightCategory
        yarn.fiberContent = fiberContent
        yarn.totalYardage = yardage
        
        try context.save()
    }
    
    enum ValidationError: Error {
        case invalidYardage
    }
}
