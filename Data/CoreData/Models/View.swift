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
