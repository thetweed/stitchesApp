//
//  ProjectViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/17/25.
//

import SwiftUI
import CoreData

class ProjectDetailViewModel: ObservableObject {
    @Published var project: Project
    @Published var showingEditSheet = false
    
    init(project: Project) {
        self.project = project
    }
    
    var statusText: String {
        "Status: \(project.status)"
    }
    
    var startDateText: String {
        "Started: \(project.startDate)"
    }
    
    var lastModifiedText: String {
        "Last modified: \(project.lastModified)"
    }
    
    var currentRowText: String {
        "Current Row: \(project.currentRow)"
    }
    
    var patternNotes: String {
        project.patternNotes ?? "No pattern notes"
    }
    
    var hasYarns: Bool {
        guard let yarns = project.yarns else { return false }
        return !yarns.isEmpty
    }
    
    var yarns: Set<Yarn> {
        project.yarns ?? Set()
    }
    
    var sortedYarns: [Yarn] {
        yarns.sorted { $0.colorName < $1.colorName }
    }
    
    func removeYarn(_ yarn: Yarn) {
        project.yarns?.remove(yarn)
    }
}
