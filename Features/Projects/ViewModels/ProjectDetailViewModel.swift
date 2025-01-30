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
    @Published private(set) var yarns: [Yarn] = []
    @Published private(set) var counters: [Counter] = []
    
    private let context: NSManagedObjectContext
    
    init(project: Project, context: NSManagedObjectContext) {
        self.project = project
        self.context = context
        self.yarns = project.yarnsArray
        self.counters = Array(project.counters?.allObjects as? [Counter] ?? [])
        self.refreshYarns()
        self.refreshCounters()
        self.refreshData()
    }
    
    var statusText: String {
        "Status: \(project.status)"
    }
    
    var startDateText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "Started: \(formatter.string(from: project.startDate))"
    }
    
    var lastModifiedText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return "Last modified: \(formatter.string(from: project.lastModified))"
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
