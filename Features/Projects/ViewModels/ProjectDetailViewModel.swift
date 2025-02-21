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
    @Published var isDeleted = false
    @Published private(set) var yarns: [Yarn] = []
    @Published private(set) var counters: [Counter] = []
    
    private let context: NSManagedObjectContext
    private let projectID: String
    
    init(project: Project, context: NSManagedObjectContext) {
        self.project = project
        self.context = context
        self.projectID = project.id.uuidString
        self.yarns = project.yarnsArray
        self.counters = Array(project.counters?.allObjects as? [Counter] ?? [])
        self.refreshYarns()
        self.refreshCounters()
        self.refreshData()
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("ProjectDeleted"),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let deletedProjectIDString = notification.userInfo?["projectIDString"] as? String,
               deletedProjectIDString == self?.projectID {  // Compare strings instead of UUID
                self?.handleDeletion()
            }
        }
    }
    
    var statusText: String {
        guard !isDeleted else { return "" }
        return "Status: \(project.status)"
    }
    
    
    var startDateText: String {
        guard !isDeleted else { return "" }
        return ProjectDateFormatter.shared.string(from: project.startDate)
    }
    
    var lastModifiedText: String {
        guard !isDeleted else { return "" }
        return ProjectDateFormatter.shared.string(from: project.lastModified)
    }
    
    var currentRowText: String {
        "Current Row: \(project.currentRow)"
    }
    
    var patternNotes: String {
        project.patternNotes ?? "No pattern notes"
    }
    
    var hasYarns: Bool {
        !yarnsArray.isEmpty
    }
    
    var yarnsArray: [Yarn] {
        project.yarnsArray
    }
    
    func removeYarn(_ yarn: Yarn) {
        context.performAndWait {
            project.removeYarn(yarn, context: context)
            objectWillChange.send()
        }
    }
    
    func refreshData() {
        context.performAndWait {
            context.refresh(project, mergeChanges: true)
            self.yarns = project.yarnsArray
            self.counters = project.countersArray
            
            print("Refreshed project data - Counters count: \(self.counters.count)")
        }
        objectWillChange.send()
    }
    
    func refreshCounters() {
        context.performAndWait {
            context.refresh(project, mergeChanges: true)
            self.counters = project.countersArray
            print("Refreshed counters: Found \(counters.count) counters")
        }
        objectWillChange.send()
    }
    
    func refreshYarns() {
        yarns = project.yarnsArray
        objectWillChange.send()
    }
    
    func handleDeletion() {
        DispatchQueue.main.async { [weak self] in
            self?.isDeleted = true
            // Clear references that might cause retain cycles
            self?.counters = []
            self?.yarns = []
            self?.objectWillChange.send()
        }
    }
    
    func debugYarns() {
#if DEBUG
        print("📊 ViewModel Yarn Debug:")
        print("Project: \(project.name)")
        print("Yarns count in ViewModel: \(yarnsArray.count)")
        
        let coreDataYarns = project.yarns as? Set<Yarn> ?? []
        print("CoreData yarns count: \(coreDataYarns.count)")
        
        let yarnsSet = Set(yarnsArray)
        let matchingYarns = yarnsSet.intersection(coreDataYarns)
        print("Matching yarns count: \(matchingYarns.count)")
        print("Mismatched yarns count: \(yarnsSet.count - matchingYarns.count)")
        
        print("\nDetailed Yarn Information:")
        yarnsArray.forEach { yarn in
            print("- Yarn: \(yarn.colorName)")
            print("  Brand: \(yarn.brand)")
            print("  ID: \(yarn.id)")
        }
#endif
    }
}

