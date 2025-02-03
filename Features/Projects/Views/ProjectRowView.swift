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
    
    private var statusColor: Color {
        switch project.status {
        case "In Progress":
            return .blue
        case "Completed":
            return .green
        case "Frogged":
            return .red
        default: // Not Started
            return Color(.darkGray)
        }
    }
    
    private var statusIcon: String {
        switch project.status {
        case "In Progress":
            return "scissors"
        case "Completed":
            return "checkmark.circle.fill"
        case "Frogged":
            return "scissors"
        default: // Not Started
            return "doc.text"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Project Name and Status Badge
            HStack(alignment: .center, spacing: 8) {
                Text(project.name)
                    .font(.headline)
                
                Spacer()
                
                // Status Badge
                HStack(spacing: 4) {
                    Image(systemName: statusIcon)
                        .font(.caption)
                    Text(project.status)
                        .font(.caption)
                }
                .foregroundStyle(statusColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(statusColor.opacity(0.15))
                )
            }
            
            HStack(spacing: 16) {
                if project.yarnsArray.count > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "circle.hexagongrid.fill")
                            .font(.caption)
                        Text("\(project.yarnsArray.count) yarn\(project.yarnsArray.count == 1 ? "" : "s")")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
                
                if project.status != "Not Started" {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.and.down")
                            .font(.caption)
                        Text("Row \(project.currentRow)")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(project.lastModified.formatted(.relative(presentation: .named)))
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                
                Spacer()
            }
        }
    }
}
