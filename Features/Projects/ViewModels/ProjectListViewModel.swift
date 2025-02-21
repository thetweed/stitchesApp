//
//  ProjectListViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/23/25.
//
import SwiftUI
import CoreData

class ProjectListViewModel: ObservableObject {
    @Published var showingAddProject = false {
        didSet {
#if DEBUG
            print("showingAddProject didSet: \(showingAddProject)")
#endif
            objectWillChange.send()
        }
    }
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(managedObjectContextObjectsDidChange),
            name: .NSManagedObjectContextObjectsDidChange,
            object: viewContext
        )
    }
    
    func projectFetchRequest() -> NSFetchRequest<Project> {
        let request = Project.fetchRequest() as! NSFetchRequest<Project>
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Project.lastModified, ascending: false),
            NSSortDescriptor(keyPath: \Project.name, ascending: true)
        ]
        request.predicate = NSPredicate(format: "deleted == NO")
        return request
    }
    
    @objc private func managedObjectContextObjectsDidChange() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func toggleAddProject() {
        showingAddProject.toggle()
#if DEBUG
        print("Toggle called: \(showingAddProject)")
#endif
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

