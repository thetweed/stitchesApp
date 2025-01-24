//
//  SettingsViewModel.swift
//  stitchesApp
//
//  Created by Laurie on 1/16/25.
//

import SwiftUI
import CoreData

class SettingsViewModel: ObservableObject {
    
    static let shared = SettingsViewModel()
    
/*    @Published var showSettings: Bool = false
    @Published var showAbout: Bool = false
    @Published var showReset: Bool = false
    @Published var showAppTheme: Bool = false
    @Published var showLanguage: Bool = false
    @Published var showMeasurementSystem: Bool = false
 */
    
//settings options
    enum AppTheme: String, CaseIterable {
        case light
        case dark
        case system
    }

    enum Language: String, CaseIterable {
        case english = "English"
        case french = "French"
    }

    enum MeasurementSystem: String, CaseIterable {
        case metric
        case imperial
    }
    
//setting defaults/storing changes to settings options
    
    @UserDefaultsStorage(key: "AppTheme", defaultValue: .system)
    var appTheme: AppTheme {
        willSet { objectWillChange.send()
            applyAppThemeSettings(theme: newValue)}
    }

    @UserDefaultsStorage(key: "Language", defaultValue: .english)
    var language: Language {
        willSet { objectWillChange.send()
            applyLanguageSettings()}
    }

    @UserDefaultsStorage(key: "MeasurementSystem", defaultValue: .metric)
    var measurementSystem: MeasurementSystem {
        willSet { objectWillChange.send()
            applyMeasurementSystemSettings()}
    }
    
//functions to change the app based on changes to settings options
    private func applyLanguageSettings() {
        // Get the current language selection
            let selectedLanguage = language
            
        // Get the language code for the selected language
            let languageCode: String = {
                switch selectedLanguage {
                case .english:
                    return "en"
                case .french:
                    return "fr"
                }
            }()
            
        // Update the app's language
            if let languageID = Bundle.main.preferredLocalizations.first,
               languageID != languageCode {
                // Set the language identifier for the next app launch
                UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                
            // NEED TO: Add functionality to show an alert/message that app needs to be restarted to apply language changes

            }
        }
    
    private func applyMeasurementSystemSettings() {
        // Get the current measurement system selection
            let selectedSystem = measurementSystem
            
        // Update the locale's measurement system
            let locale = selectedSystem == .metric ? "metric" : "imperial"
            UserDefaults.standard.set([locale], forKey: "AppleMetricSystem")
            UserDefaults.standard.synchronize()
        
        /*Notification to broadcast the measurement system change
         NotificationCenter.default.post(
             name: Notification.Name("MeasurementSystemChanged"),
             object: nil,
             userInfo: ["system": selectedSystem]
         )*/
    }
    
    private func applyAppThemeSettings(theme: AppTheme) {
        // Apply the selected theme
            if #available(iOS 13.0, *) {
                let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let window = scene?.windows.first
                
                switch theme {
                case .light:
                    window?.overrideUserInterfaceStyle = .light
                case .dark:
                    window?.overrideUserInterfaceStyle = .dark
                case .system:
                    window?.overrideUserInterfaceStyle = .unspecified
                }
            }
            
            // Post notification for any views that need to update their appearance
            NotificationCenter.default.post(
                name: Notification.Name("AppThemeChanged"),
                object: nil,
                userInfo: ["theme": theme]
            )
    }
}

//allows saving user choices for defaults
@propertyWrapper
struct UserDefaultsStorage<T: RawRepresentable> where T.RawValue == String {
    let key: String
    let defaultValue: T
    let defaults = UserDefaults.standard
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            guard let rawValue = defaults.string(forKey: key),
                  let value = T(rawValue: rawValue) else {
                return defaultValue
            }
            return value
        }
        set {
            defaults.set(newValue.rawValue, forKey: key)
        }
    }
}
