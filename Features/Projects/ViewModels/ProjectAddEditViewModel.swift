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
    @Published var showingNewCounterSheet = false
    @Published var showingAttachCounterSheet = false
    @Published var countersToAttach: Set<Counter> = []
    @Published var attachedCounters: [Counter] = []
    @Published var showYarnSelection = false
    
    let statuses = ["Not Started", "In Progress", "Completed", "Frogged"]
    private let viewContext: NSManagedObjectContext
   let existingProject: Project?

    //new project
    init(viewContext: NSManagedObjectContext) {
        self.existingProject = nil
        self.viewContext = viewContext
    }
    //existing project
    init(project: Project, viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.existingProject = project
        
        self.name = project.name
        self.patternNotes = project.patternNotes ?? ""
        self.status = project.status
        self.currentRow = project.currentRow
        self.yarns = project.yarns as? Set<Yarn> ?? []
        self.attachedCounters = Array(project.counters?.allObjects as? [Counter] ?? [])
    }
    
    var sortedYarns: [Yarn] {
        yarns.sorted { $0.colorName < $1.colorName }
    }
    
    var isValid: Bool {
        !name.isEmpty
    }
    
    func updateProject() {
        guard let project = existingProject, isValid else { return }
            
            viewContext.performAndWait {
                project.name = name
                project.patternNotes = patternNotes
                project.status = status
                project.currentRow = currentRow
                project.lastModified = Date()
                
                let currentYarns = project.yarns as? Set<Yarn> ?? []
                currentYarns.subtracting(yarns).forEach { yarn in
                    project.removeYarn(yarn, context: viewContext)
                }
                yarns.subtracting(currentYarns).forEach { yarn in
                    project.addYarn(yarn, context: viewContext)
                }
                
                    countersToAttach.forEach { counter in
                    project.addToCounters(counter)
                    counter.project = project
                }
                attachedCounters = Array(project.counters?.allObjects as? [Counter] ?? [])
                
                do {
                    try viewContext.save()
                    print("Project updated successfully with \(attachedCounters.count) counters")
                } catch {
                    print("Error updating project: \(error)")
                }
            }
        }
    
    func refreshAttachedCounters() {
        if let project = existingProject {
            viewContext.refresh(project, mergeChanges: true)
            attachedCounters = Array(project.counters?.allObjects as? [Counter] ?? [])
            objectWillChange.send()
        }
    }
    
    func detachCounter(_ counter: Counter) {
        viewContext.performAndWait {
            counter.project = nil
            try? viewContext.save()
            attachedCounters.removeAll(where: { $0.id == counter.id })
        }
    }

    
    func saveProject() {
        print("\n--- Beginning saveProject in ViewModel ---")
        viewContext.performAndWait {
            print("Creating new project in context")
            let project = Project.create(
                in: viewContext,
                name: name,
                projectType: "Knitting",
                startDate: Date()
            )
            
            project.patternNotes = patternNotes
            project.status = status
            project.currentRow = currentRow
            
            yarns.forEach { yarn in
                project.addYarn(yarn, context: viewContext)
            }
            
            countersToAttach.forEach { counter in
                project.addToCounters(counter)
                counter.project = project
            }
            
            do {
                print("Attempting to save new project to context")
                try viewContext.save()
                print("Successfully saved new project")
                
                // Debug current state
                let projectCount = try viewContext.count(for: NSFetchRequest(entityName: "Project"))
                print("Total projects after save: \(projectCount)")
            } catch {
                print("Failed to save new project: \(error)")
            }
        }
        print("--- Completed saveProject in ViewModel ---\n")
    }
    
    func addYarn(_ yarn: Yarn) {
        yarns.insert(yarn)
    }
    
    func removeYarn(_ yarn: Yarn) {
        yarns.remove(yarn)
    }
}
