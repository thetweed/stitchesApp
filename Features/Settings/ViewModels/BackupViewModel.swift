//
//  Untitled.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//

import SwiftUI
import CoreData

class BackupViewModel: ObservableObject {
    @Published var showError = false
    @Published var errorMessage = ""
    
    func exportData() async {
        do {
            // Implementation for exporting all data
            let encoder = JSONEncoder()
            // Get managed object context
            // Fetch all entities
            // Encode to JSON
            // Save to file
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
    
    func importData() async {
        do {
            // Implementation for importing data
            // Show document picker
            // Load JSON
            // Parse into Core Data entities
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
}
