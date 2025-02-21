//
//  SettingsView.swift
//  stitchesApp
//
//  Created by Laurie on 1/16/25.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    @StateObject private var settings = SettingsViewModel.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    Picker("Theme", selection: $settings.appTheme) {
                        ForEach(SettingsViewModel.AppTheme.allCases, id: \.self) { theme in
                            Text(theme.rawValue.capitalized).tag(theme)
                        }
                    }
                    
                    Toggle("Increase Contrast", isOn: $settings.highContrast)
                    Toggle("Bold Text", isOn: $settings.boldText)
                } header: {
                    Label("Display", systemImage: "paintbrush.fill")
                }
                
                Section {
                    Picker("Language", selection: $settings.language) {
                        ForEach(SettingsViewModel.Language.allCases, id: \.self) { language in
                            Text(language.rawValue.capitalized).tag(language)
                        }
                    }
                    
                    Picker("Units", selection: $settings.measurementSystem) {
                        ForEach(SettingsViewModel.MeasurementSystem.allCases, id: \.self) { system in
                            Text(system.rawValue.capitalized).tag(system)
                        }
                    }
                } header: {
                    Label("Preferences", systemImage: "gearshape.fill")
                }
                
                Section {
                    Toggle("Auto-increment Row Counter", isOn: $settings.autoIncrementRows)
                    Toggle("Show Project Notes by Default", isOn: $settings.showNotesByDefault)
                    Toggle("Show Completed Projects", isOn: $settings.showCompletedProjects)
                } header: {
                    Label("Project Defaults", systemImage: "scissors")
                }
                Section {
                    NavigationLink {
                        BackupView()
                    } label: {
                        Label("Backup & Data", systemImage: "externaldrive.fill")
                    }
                }
                
                Section {
                    NavigationLink {
                        
                        Text("Help Content")
                    } label: {
                        Label("Help & Tips", systemImage: "questionmark.circle")
                    }
                    
                    Link(destination: URL(string: "https://yourwebsite.com/privacy")!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    
                    
                    Label("Version 1.0.0", systemImage: "info.circle")
                        .foregroundColor(.secondary)
                } header: {
                    Label("About", systemImage: "info.circle")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}

//Add reminders or whatever notifications later?
/* Section {
 Toggle("Project Reminders", isOn: $settings.enableReminders)
 if settings.enableReminders {
 Toggle("Daily Progress Notifications", isOn: $settings.dailyNotifications)
 Toggle("Inactive Project Reminders", isOn: $settings.inactiveProjectReminders)
 }
 } header: {
 Label("Notifications", systemImage: "bell.fill")
 }*/
