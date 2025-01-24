//
//  Yarn.swift
//  stitchesApp
//
//  Created by Laurie on 1/14/25.
//

import Foundation
import CoreData

// Yarn Entity
class Yarn: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var brand: String
    @NSManaged public var colorName: String
    @NSManaged public var colorNumber: String?
    @NSManaged public var weightCategory: String // Lace, Super Fine, Fine, Light, Medium, Bulky, Super Bulky, Jumbo
    @NSManaged public var fiberContent: String?
    @NSManaged public var totalYardage: Double
    @NSManaged public var usedYardage: Double
    @NSManaged public var purchaseDate: Date?
    @NSManaged public var price: Decimal
    @NSManaged public var projects: Set<Project>?
    @NSManaged public var photoData: Data?
}

extension Yarn {
    // Convenience initializer
    @discardableResult
    static func create(in context: NSManagedObjectContext,
                      brand: String,
                      colorName: String,
                      weightCategory: String,
                      fiberContent: String,
                      totalYardage: Double) -> Yarn {
        let yarn = Yarn(context: context)
        yarn.id = UUID()
        yarn.brand = brand
        yarn.colorName = colorName
        yarn.weightCategory = weightCategory
        yarn.fiberContent = fiberContent
        yarn.totalYardage = totalYardage
        yarn.usedYardage = 0
        yarn.price = 0
        return yarn
    }
    
    // Yarn weight categories
    static let weightCategories = [
        "Lace", "Super Fine", "Fine", "Light", "Medium",
        "Bulky", "Super Bulky", "Jumbo"
    ]
    
    // Computed property for remaining yardage
    var remainingYardage: Double {
        return totalYardage - usedYardage
    }
}
