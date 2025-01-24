//
//  ProjectEditViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/23/25.
//

import SwiftUI
import CoreData

class ProjectEditViewModel: ObservableObject {
    @Published var name: String
    @Published var patternNotes: String
    @Published var status: String
    @Published var currentRow: Int32
    @Published var yarns: Set<Yarn>
    
    let statuses = ["Not Started", "In Progress", "Completed", "Frogged"]
    private let project: Project
    private let viewContext: NSManagedObjectContext
    
    init(project: Project, viewContext: NSManagedObjectContext) {
        self.project = project
        self.viewContext = viewContext
        self.name = project.name
        self.patternNotes = project.patternNotes ?? ""
        self.status = project.status
        self.currentRow = project.currentRow
        self.yarns = project.yarns ?? Set<Yarn>()
    }
    
    var sortedYarns: [Yarn] {
        Array(yarns).sorted { ($0.colorName) < ($1.colorName) }
    }
    
    var isValid: Bool {
        !name.isEmpty
    }
    
    func updateProject() {
        project.name = name
        project.patternNotes = patternNotes
        project.status = status
        project.currentRow = currentRow
        project.yarns = yarns
        project.lastModified = Date()
        
        try? viewContext.save()
    }
}
