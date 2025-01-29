//
//  Notification.Name.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//

import SwiftUI
import CoreData

extension Notification.Name {
    static let settingsChanged = Notification.Name("SettingsChanged")
    static let highContrastChanged = Notification.Name("HighContrastChanged")
    static let boldTextChanged = Notification.Name("BoldTextChanged")
    static let projectDefaultsChanged = Notification.Name("ProjectDefaultsChanged")
}
