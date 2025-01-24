//
//  ProjectListViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/23/25.
//
import SwiftUI
import CoreData

class ProjectListViewModel: ObservableObject {
    @Published var showingAddProject = false
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func projectFetchRequest() -> NSFetchRequest<Project> {
        let request: NSFetchRequest<Project> = Project.fetchRequest() as! NSFetchRequest<Project>
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.name, ascending: true)]
        request.predicate = NSPredicate(format: "deleted == NO")
        return request
    }
    
    func toggleAddProject() {
        showingAddProject.toggle()
    }
}