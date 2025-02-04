//
//  ProjectRepository.swift
//  stitchesApp
//
//  Created by Laurie on 1/14/25.
//

import SwiftUI
import CoreData



/*
 class ProjectRepository {
     private let viewContext: NSManagedObjectContext
     
     init(viewContext: NSManagedObjectContext) {
         self.viewContext = viewContext
     }
     
     // MARK: - Fetch Requests
     
     func projectsFetchRequest() -> NSFetchRequest<Project> {
         let request: NSFetchRequest<Project> = Project.fetchRequest()
         request.sortDescriptors = [
             NSSortDescriptor(keyPath: \Project.lastModified, ascending: false),
             NSSortDescriptor(keyPath: \Project.name, ascending: true)
         ]
         request.predicate = NSPredicate(format: "deleted == NO")
         return request
     }
     
     func fetchProjectsByStatus(_ status: String) -> NSFetchRequest<Project> {
         let request = projectsFetchRequest()
         request.predicate = NSPredicate(format: "status == %@ AND deleted == NO", status)
         return request
     }
     
     // MARK: - CRUD Operations
     
     @discardableResult
     func createProject(
         name: String,
         projectType: String,
         status: String = "Not Started"
     ) -> Project {
         viewContext.performAndWait {
             let project = Project.create(
                 in: viewContext,
                 name: name,
                 projectType: projectType
             )
             project.status = status
             save()
             return project
         }
     }
     
     func softDeleteProject(_ project: Project) {
         viewContext.performAndWait {
             project.deleted = true
             project.lastModified = Date()
             save()
         }
     }
     
     func hardDeleteProject(_ project: Project) {
         viewContext.performAndWait {
             viewContext.delete(project)
             save()
         }
     }
     
     // MARK: - Batch Operations
     
     func batchDeleteProjects(_ projects: [Project], soft: Bool = true) {
         viewContext.performAndWait {
             if soft {
                 projects.forEach { $0.deleted = true }
             } else {
                 projects.forEach { viewContext.delete($0) }
             }
             save()
         }
     }
     
     func archiveCompletedProjects() {
         let request = NSFetchRequest<Project>(entityName: "Project")
         request.predicate = NSPredicate(format: "status == %@ AND deleted == NO", "Completed")
         
         viewContext.performAndWait {
             do {
                 let completedProjects = try viewContext.fetch(request)
                 completedProjects.forEach { $0.deleted = true }
                 save()
             } catch {
                 print("Error archiving completed projects: \(error)")
             }
         }
     }
     
     // MARK: - Utilities
     
     private func save() {
         guard viewContext.hasChanges else { return }
         
         do {
             try viewContext.save()
         } catch {
             print("Error saving context: \(error)")
             viewContext.rollback()
         }
     }
 }
 */



//OLD
/*class ProjectRepository: Identifiable {
    
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

*/
