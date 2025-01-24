//
//  ProjectRepository.swift
//  stitchesApp
//
//  Created by Laurie on 1/14/25.
//

import SwiftUI
import CoreData

class ProjectRepository: Identifiable {
    
    let viewContext: NSManagedObjectContext
    
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    // Save check
    private func save() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
        
    // Create a project
    func createProject(name: String, projectType: String) -> Project {
        let project = Project.create(in: viewContext,
                                        name: name,
                                        projectType: projectType)
        save()
        return project
    }
        
    // Read
    func fetchProjects() -> [Project] {
        let request = NSFetchRequest<Project>(entityName: "Project")
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching projects: \(error)")
        }
        return []
    }
        
    // Update project, update date last modified
    func updateProject(_ project: Project) {
        project.lastModified = Date()
        save()
    }
        
    // Delete
    func deleteProject(_ project: Project) {
        viewContext.delete(project)
        save()
    }
}

