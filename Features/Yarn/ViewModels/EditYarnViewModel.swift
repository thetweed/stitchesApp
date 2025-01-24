//
//  EditYarnViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/23/25.
//

import SwiftUI
import CoreData

class EditYarnViewModel: ObservableObject {
    @Published var brand = ""
    @Published var colorName = ""
    @Published var weightCategory = ""
    @Published var fiberContent = ""
    @Published var totalYardage = ""
    private let yarn: Yarn
    
    init(yarn: Yarn) {
        self.yarn = yarn
        self.brand = yarn.brand
        self.colorName = yarn.colorName
        self.weightCategory = yarn.weightCategory
        self.fiberContent = yarn.fiberContent ?? ""
        self.totalYardage = String(yarn.totalYardage)
    }
    
    var isFormValid: Bool {
        !brand.isEmpty &&
        !colorName.isEmpty &&
        !weightCategory.isEmpty &&
        !fiberContent.isEmpty &&
        Double(totalYardage) != nil
    }
    
    func saveChanges() throws {
        guard let yardage = Double(totalYardage) else {
            throw ValidationError.invalidYardage
        }
        
        let context = CoreDataManager.shared.container.viewContext
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
