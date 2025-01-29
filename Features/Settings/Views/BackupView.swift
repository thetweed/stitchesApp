//
//  BackupView.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//

import SwiftUI
import CoreData

struct BackupView: View {
    @StateObject private var backupViewModel = BackupViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Section {
                Button {
                    Task {
                        await backupViewModel.exportData()
                    }
                } label: {
                    Label("Export All Data", systemImage: "square.and.arrow.up")
                }
                
                Button {
                    Task {
                        await backupViewModel.importData()
                    }
                } label: {
                    Label("Import Data", systemImage: "square.and.arrow.down")
                }
            } header: {
                Text("Backup Options")
            } footer: {
                Text("Exports will include all projects, counters, and yarn data.")
            }
        }
        .navigationTitle("Backup & Data")
        .alert("Export Error", isPresented: $backupViewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(backupViewModel.errorMessage)
        }
    }
}
