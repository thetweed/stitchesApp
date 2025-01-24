//
//  AddProjectViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/23/25.
//

import SwiftUI
import CoreData

class AddProjectViewModel: ObservableObject {
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
