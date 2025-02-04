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
        let yarn = Yarn.create(
            in: context,
            brand: "Sample Brand",
            colorName: "Sample Color",
            weightCategory: weightCategories[0],
            fiberContent: "Wool/Acrylic",
            totalYardage: 100.0
        )
        return yarn
    }
}
