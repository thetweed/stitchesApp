//
//  AddProjectViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/23/25.
//

import SwiftUI
import CoreData

class AddEditProjectViewModel: ObservableObject {
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
/*class AddProjectViewModel: ObservableObject {
    @Published var name = ""
    @Published var patternNotes = ""
    @Published var status = "In Progress"
    @Published var currentRow: Int32 = 1
    
    let statuses = ["Not Started", "In Progress", "Completed", "Frogged"]
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
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
    
    var isValid: Bool {
        !name.isEmpty
    }
}
*/
