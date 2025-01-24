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
    
    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Picker("Theme", selection: $settings.appTheme) {
                    ForEach(SettingsViewModel.AppTheme.allCases, id: \.self) { theme in
                        Text(theme.rawValue.capitalized).tag(theme)
                    }
                }
            }
            
            Section(header: Text("Language")) {
                Picker("Language", selection: $settings.language) {
                    ForEach(SettingsViewModel.Language.allCases, id: \.self) { language in
                        Text(language.rawValue.capitalized).tag(language)
                    }
                }
            }
            
            Section(header: Text("Measurement System")) {
                Picker("Units", selection: $settings.measurementSystem) {
                    ForEach(SettingsViewModel.MeasurementSystem.allCases, id: \.self) { system in
                        Text(system.rawValue.capitalized).tag(system)
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
