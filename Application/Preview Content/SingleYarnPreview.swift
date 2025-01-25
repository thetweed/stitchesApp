//
//  SingleYarnPreview.swift
//  stitchesApp
//
//  Created by Laurie on 1/24/25.
//
import SwiftUI
import CoreData

fileprivate extension Yarn {
    static func previewSample(context: NSManagedObjectContext) -> Yarn {
        let yarn = Yarn(context: context)
        yarn.id = UUID()
        yarn.brand = "Sample Brand"
        yarn.colorName = "Sample Color"
        yarn.weightCategory = weightCategories[0]
        yarn.fiberContent = "Wool/Acrylic"
        yarn.totalYardage = 100
        yarn.usedYardage = 0
        return yarn
    }
}