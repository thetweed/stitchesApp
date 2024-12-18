//
//  stitchesAppApp.swift
//  stitchesApp
//
//  Created by Laurie on 12/18/24.
//

import SwiftUI

@main
struct stitchesAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
