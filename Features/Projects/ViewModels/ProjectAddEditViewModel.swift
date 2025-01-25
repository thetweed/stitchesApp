//
//  ProjectEditViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/23/25.
//

import SwiftUI
import CoreData

class ProjectAddEditViewModel: ObservableObject {
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
        yarns.sorted { $0.colorName < $1.colorName }
    }
    
    var isValid: Bool {
        !name.isEmpty
    }
    
    func updateProject() {
        guard isValid else { return }
        
        project.name = name
        project.patternNotes = patternNotes
        project.status = status
        project.currentRow = currentRow
        project.lastModified = Date()
        
        // Remove all existing yarns
        project.yarns?.forEach { project.removeFromYarns($0) }
        
        // Add new yarns
        yarns.forEach { project.addToYarns($0) }
        
        try? viewContext.save()
    }
    
    func saveProject() {
        let project = Project(context: viewContext)
        project.id = UUID()
        project.name = name
        project.patternNotes = patternNotes
        project.status = status
        project.currentRow = currentRow
        project.startDate = Date()
        project.lastModified = Date()
        
        try? viewContext.save()
    }
    
    func addYarn(_ yarn: Yarn) {
        yarns.insert(yarn)
    }
    
    func removeYarn(_ yarn: Yarn) {
        yarns.remove(yarn)
    }
}


/*class ProjectEditViewModel: ObservableObject {
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
        guard isValid else { return }
        
        project.name = name
        project.patternNotes = patternNotes
        project.status = status
        project.currentRow = currentRow
        project.lastModified = Date()
        
        // Set yarns safely
        if let yarnSet = yarns as? Set<Yarn> {
            project.yarns = yarnSet
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
*/
