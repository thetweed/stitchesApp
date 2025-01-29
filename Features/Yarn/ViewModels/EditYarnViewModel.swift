//
//  EditYarnViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/23/25.
//

import SwiftUI
import CoreData

class EditYarnViewModel: ObservableObject {
    @Published var brand: String
    @Published var colorName: String
    @Published var colorNumber: String
    @Published var weightCategory: String
    @Published var fiberContent: String
    @Published var totalYardage: Double
    
    private let yarn: Yarn
    private let context: NSManagedObjectContext
    
    init(yarn: Yarn) {
        self.yarn = yarn
        self.context = yarn.managedObjectContext ?? CoreDataManager.shared.container.viewContext
        
        self.brand = yarn.brand
        self.colorName = yarn.colorName
        self.colorNumber = yarn.colorNumber ?? ""
        self.weightCategory = yarn.weightCategory
        self.fiberContent = yarn.fiberContent ?? ""
        self.totalYardage = yarn.totalYardage
    }
    
    var isFormValid: Bool {
        !brand.isEmpty &&
        !colorName.isEmpty &&
        !weightCategory.isEmpty &&
        !fiberContent.isEmpty &&
        totalYardage > yarn.usedYardage
    }
    
    func saveChanges() throws {
        guard totalYardage > yarn.usedYardage else {
            throw ValidationError.invalidYardage
        }
        
        context.performAndWait {
            yarn.brand = brand
            yarn.colorName = colorName
            yarn.colorNumber = colorNumber.isEmpty ? nil : colorNumber
            yarn.weightCategory = weightCategory
            yarn.fiberContent = fiberContent
            yarn.totalYardage = totalYardage
            
            do {
                try context.save()
                NotificationCenter.default.post(
                    name: NSNotification.Name("YarnDidUpdate"),
                    object: nil,
                    userInfo: ["yarnID": yarn.objectID]
                )
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
                return "Total yardage must be greater than used yardage"
            }
        }
    }
}

