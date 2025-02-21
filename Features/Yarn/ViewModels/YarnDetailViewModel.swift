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
    private let dateFormatter: DateFormatter
    
    init(yarn: Yarn) {
        self.yarn = yarn
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .medium
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
        let remainingYardage = yarn.remainingYardage
        return "Yardage: \(String(format: "%.1f", yarn.totalYardage)) total, \(String(format: "%.1f", remainingYardage)) remaining"
    }
    
    var fiberContentText: String {
        "Fiber Content: \(yarn.fiberContent ?? "Not specified")"
    }
    
    var purchaseDateText: String {
        guard let purchaseDate = yarn.purchaseDate else {
            return "Purchase Date: Not recorded"
        }
        return "Purchased: \(dateFormatter.string(from: purchaseDate))"
    }
    
    var hasProjects: Bool {
        !projectsArray.isEmpty
    }
    
    var projectsArray: [Project] {
        yarn.projectsArray
    }
}
