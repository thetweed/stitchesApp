//
//  ProjectEditViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/23/25.
//

import SwiftUI
import CoreData

class ProjectAddEditViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var patternNotes: String = ""
    @Published var status: String = "Not Started"
    @Published var currentRow: Int32 = 0
    @Published var yarns: Set<Yarn> = []
    
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
        yarns.sorted { $0.colorName < $1.colorName }
    }
    
    var isValid: Bool {
        !name.isEmpty
    }
    
    func updateProject() {
        guard isValid else { return }
        
        viewContext.performAndWait {
            project.name = name
            project.patternNotes = patternNotes
            project.status = status
            project.currentRow = currentRow
            project.lastModified = Date()
            
            project.yarns?.forEach { project.removeFromYarns($0) }
            yarns.forEach { project.addToYarns($0) }
            
            try? viewContext.save()
        }
    }
    
    func saveProject() {
        viewContext.performAndWait {
            let project = Project(context: viewContext)
            project.id = UUID()
            project.name = name
            project.patternNotes = patternNotes
            project.status = status
            project.currentRow = currentRow
            project.startDate = Date()
            project.lastModified = Date()
            
            project.yarns?.forEach { project.removeFromYarns($0) }
            yarns.forEach { project.addToYarns($0) }
            
            try? viewContext.save()
        }
    }
    
    func addYarn(_ yarn: Yarn) {
        yarns.insert(yarn)
    }
    
    func removeYarn(_ yarn: Yarn) {
        yarns.remove(yarn)
    }
}
