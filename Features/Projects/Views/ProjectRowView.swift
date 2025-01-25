//
//  ProjectRowView.swift
//  stitchesApp
//
//  Created by Laurie on 1/17/25.
//

import SwiftUI
import CoreData

struct ProjectRowView: View {
    @ObservedObject var project: Project
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(project.name)
                .font(.headline)
            HStack {
                Text("Status: \(project.status)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Row \(project.currentRow)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
