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
        self.yarns = project.yarns ?? []
    }
    
    var sortedYarns: [Yarn] {
        yarns.sorted { $0.colorName < $1.colorName }
    }
    
    var isValid: Bool {
        !name.isEmpty
    }
    
    /*func updateProject() {
        guard isValid else { return }
        
        viewContext.performAndWait {
            project.name = name
            project.patternNotes = patternNotes
            project.status = status
            project.currentRow = currentRow
            project.lastModified = Date()
            
            let currentYarns = project.yarns ?? Set<Yarn>()
            
            let yarnsToRemove = currentYarns.subtracting(yarns)
            let yarnsToAdd = yarns.subtracting(currentYarns)
            
            yarnsToRemove.forEach { project.removeFromYarns($0) }
            yarnsToAdd.forEach { project.addToYarns($0) }
            
            try? viewContext.save()
        }
    }*/
    
    func updateProject() {
        guard isValid else { return }
        
        viewContext.performAndWait {
            project.name = name
            project.patternNotes = patternNotes
            project.status = status
            project.currentRow = currentRow
            project.lastModified = Date()
            let currentYarns = project.yarns ?? Set<Yarn>()
            
            currentYarns.subtracting(yarns).forEach { yarn in
                project.removeFromYarns(yarn)
                yarn.removeFromProjects(project)
            }

            yarns.subtracting(currentYarns).forEach { yarn in
                project.addToYarns(yarn)
                yarn.addToProjects(project)
            }
            
            do {
                try viewContext.save()
            } catch {
                print("Failed to save context: \(error)")
            }
#if DEBUG
print("Before update - Current yarns count: \(currentYarns.count)")
print("View model yarns count: \(yarns.count)")
#endif
        }
#if DEBUG
print("After update - Project yarns count: \(project.yarns?.count ?? 0)")
#endif
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


//            project.yarns?.forEach { project.removeFromYarns($0) }
//            yarns.forEach { project.addToYarns($0) }
