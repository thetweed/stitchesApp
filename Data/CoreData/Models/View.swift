//
//  View.swift
//  stitchesApp
//
//  Created by Laurie on 1/25/25.
//
import SwiftUI
import CoreData

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
    }
}



/*struct BoldTextModifier: ViewModifier {
    @StateObject private var settings = SettingsViewModel.shared
    
    func body(content: Content) -> Content {
        content.fontWeight(settings.boldText ? .bold : .regular)
    }
}

extension View {
    func adaptiveBoldText() -> some View {
        modifier(BoldTextModifier())
    }
}

struct HighContrastModifier: ViewModifier {
    @StateObject private var settings = SettingsViewModel.shared
    
    func body(content: Content) -> Content {
        content
            .foregroundColor(settings.highContrast ? .primary : nil)
            .background(settings.highContrast ? Color(.systemBackground) : nil)
            .contrast(settings.highContrast ? 1.5 : 1.0)
    }
}

extension View {
    func adaptiveHighContrast() -> some View {
        modifier(HighContrastModifier())
    }
}

struct AccessibilityModifier: ViewModifier {
    @StateObject private var settings = SettingsViewModel.shared
    
    func body(content: Content) -> Content {
        content
            .fontWeight(settings.boldText ? .bold : .regular)
            .foregroundColor(settings.highContrast ? .primary : nil)
            .background(settings.highContrast ? Color(.systemBackground) : nil)
            .contrast(settings.highContrast ? 1.5 : 1.0)
    }
}

extension View {
    func withAccessibilitySettings() -> some View {
        modifier(AccessibilityModifier())
    }
}
*/
