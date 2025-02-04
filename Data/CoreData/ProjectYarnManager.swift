//
//  ProjectYarnManager.swift
//  stitchesApp
//
//  Created by Laurie on 1/28/25.
//

// For use in other views/view models that just need yarn management
/*import SwiftUI
import CoreData

class ProjectYarnManager {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addYarnToProject(_ yarn: Yarn, project: Project) {
        context.performAndWait {
            project.addYarn(yarn, context: context)
            try? context.save()
        }
    }
    
    func removeYarnFromProject(_ yarn: Yarn, project: Project) {
        context.performAndWait {
            project.removeYarn(yarn, context: context)
            try? context.save()
        }
    }
    
    func debugYarnRelationship(for project: Project) {
            #if DEBUG
            print("🧶 ProjectYarnManager Debug:")
            print("Project: \(project.name)")
            print("CoreData yarns count: \(project.yarns?.count ?? 0)")
            project.yarnsArray.forEach { yarn in
                print("- Yarn: \(yarn.colorName), ID: \(yarn.id.uuidString)")
            }
            #endif
        }
}
*/
