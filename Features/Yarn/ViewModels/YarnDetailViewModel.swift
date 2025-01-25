//
//  YarnDetailViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/25/25.
//
import SwiftUI
import CoreData

class YarnDetailViewModel: ObservableObject {
    @Published var yarn: Yarn
    @Published var showingEditSheet = false
    
    init(yarn: Yarn) {
        self.yarn = yarn
    }
    
    var brandText: String {
        "Brand: \(yarn.brand)"
    }
    
    var colorDetails: String {
        "Color: \(yarn.colorName)" + (yarn.colorNumber.map { " (\($0))" } ?? "")
    }
    
    var weightCategoryText: String {
        "Weight: \(yarn.weightCategory)"
    }
    
    var yardageText: String {
        "Yardage: \(String(format: "%.1f", yarn.totalYardage)) total, \(String(format: "%.1f", yarn.usedYardage)) used"
    }
    
    var fiberContentText: String {
        "Fiber Content: \(yarn.fiberContent ?? "Not specified")"
    }
    
    var purchaseDateText: String {
        guard let purchaseDate = yarn.purchaseDate else {
            return "Purchase Date: Not recorded"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return "Purchased: \(dateFormatter.string(from: purchaseDate))"
    }
    
    var hasProjects: Bool {
        guard let projects = yarn.projects else { return false }
        return !projects.isEmpty
    }
    
    var projects: [Project] {
        Array(yarn.projects ?? Set())
    }
}
