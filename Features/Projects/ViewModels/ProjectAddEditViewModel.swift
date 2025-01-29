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
    
    let statuses = ["Not Started", "In Progress", "Completed", "Frogged"]
    let project: Project
    private let viewContext: NSManagedObjectContext
    
    init(project: Project, viewContext: NSManagedObjectContext) {
        self.project = project
        self.viewContext = viewContext
        
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
            guard isValid else { return }
            
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
        viewContext.refresh(project, mergeChanges: true)
        attachedCounters = Array(project.counters?.allObjects as? [Counter] ?? [])
        objectWillChange.send()
    }
    
    func detachCounter(_ counter: Counter) {
        viewContext.performAndWait {
            counter.project = nil
            try? viewContext.save()
            attachedCounters.removeAll(where: { $0.id == counter.id })
        }
    }
    
    func saveProject() {
        viewContext.performAndWait {
            let project = Project.create(
                in: viewContext,
                name: name,
                projectType: "knitting", // You might want to make this configurable
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
