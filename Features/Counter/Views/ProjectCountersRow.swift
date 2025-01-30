//
//  ProjectCountersRow.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//

import SwiftUI
import CoreData


struct ProjectCountersRow: View {
    @ObservedObject var project: Project
    let isExpanded: Bool
    let onTap: () -> Void
    
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
        VStack(spacing: 8) {
            Button(action: onTap) {
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
                    
                    // Project Details Row
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image(systemName: "number.circle")
                                .font(.caption)
                            Text("\(project.countersArray.count) counter\(project.countersArray.count == 1 ? "" : "s")")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                        
                        if project.status != "Not Started" {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.up.and.down")
                                    .font(.caption)
                                Text("Row \(project.currentRow)")
                                    .font(.caption)
                            }
                            .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .rotationEffect(.degrees(isExpanded ? 90 : 0))
                            .animation(.spring(), value: isExpanded)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
            }
            
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(project.countersArray) { counter in
                        NavigationLink(destination: BasicStitchCounterView(context: counter.managedObjectContext!, counter: counter)) {
                            CounterRowView(counter: counter)
                                .cardStyle()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

