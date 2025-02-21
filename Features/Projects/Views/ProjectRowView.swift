//
//  ProjectRowView.swift
//  stitchesApp
//
//  Created by Laurie on 1/17/25.
//

import SwiftUI
import CoreData

class ProjectRowViewModel: ObservableObject {
    @Published var project: Project
    @Published var isDeleted = false
    let projectID: String
    
    init(project: Project) {
        self.project = project
        self.projectID = project.id.uuidString
    }
    
    var lastModifiedText: String {
        guard !isDeleted else { return "" }
        return ProjectDateFormatter.shared.relativeString(from: project.lastModified)
    }
}

struct ProjectRowView: View {
    @StateObject private var viewModel: ProjectRowViewModel
    
    init(project: Project) {
        _viewModel = StateObject(wrappedValue: ProjectRowViewModel(project: project))
    }
    
    private var statusColor: Color {
        switch viewModel.project.status {
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
        switch viewModel.project.status {
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
        Group {
            if !viewModel.isDeleted {
                VStack(alignment: .leading, spacing: 8) {
                    // Project Name and Status Badge
                    HStack(alignment: .center, spacing: 8) {
                        Text(viewModel.project.name)
                            .font(.headline)
                        
                        Spacer()
                        
                        // Status Badge
                        HStack(spacing: 4) {
                            Image(systemName: statusIcon)
                                .font(.caption)
                            Text(viewModel.project.status)
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
                        if viewModel.project.yarnsArray.count > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "circle.hexagongrid.fill")
                                    .font(.caption)
                                Text("\(viewModel.project.yarnsArray.count) yarn\(viewModel.project.yarnsArray.count == 1 ? "" : "s")")
                                    .font(.caption)
                            }
                            .foregroundColor(.secondary)
                        }
                        
                        if viewModel.project.status != "Not Started" {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.up.and.down")
                                    .font(.caption)
                                Text("Row \(viewModel.project.currentRow)")
                                    .font(.caption)
                            }
                            .foregroundColor(.secondary)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.caption)
                            Text(viewModel.lastModifiedText)
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ProjectDeleted"))) { notification in
                    if let deletedProjectIDString = notification.userInfo?["projectIDString"] as? String,
                       deletedProjectIDString == viewModel.projectID {  // Use stored string ID
                        withAnimation {
                            viewModel.isDeleted = true
                        }
                    }
                }
            }
        }
    }
}

struct OldProjectRowView: View {
    @StateObject private var viewModel: ProjectRowViewModel
    
    init(project: Project) {
        _viewModel = StateObject(wrappedValue: ProjectRowViewModel(project: project))
    }
    
    private var statusColor: Color {
        switch viewModel.project.status {
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
        switch viewModel.project.status {
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
        if !viewModel.isDeleted {
            VStack(alignment: .leading, spacing: 8) {
                // Project Name and Status Badge
                HStack(alignment: .center, spacing: 8) {
                    Text(viewModel.project.name)
                        .font(.headline)
                    
                    Spacer()
                    
                    // Status Badge
                    HStack(spacing: 4) {
                        Image(systemName: statusIcon)
                            .font(.caption)
                        Text(viewModel.project.status)
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
                    if viewModel.project.yarnsArray.count > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "circle.hexagongrid.fill")
                                .font(.caption)
                            Text("\(viewModel.project.yarnsArray.count) yarn\(viewModel.project.yarnsArray.count == 1 ? "" : "s")")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    if viewModel.project.status != "Not Started" {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up.and.down")
                                .font(.caption)
                            Text("Row \(viewModel.project.currentRow)")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text(viewModel.lastModifiedText)
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ProjectDeleted"))) { notification in
                if let deletedProjectIDString = notification.userInfo?["projectIDString"] as? String,
                   deletedProjectIDString == viewModel.project.id.uuidString {
                    withAnimation {
                        viewModel.isDeleted = true
                    }
                }
            }
            
        } else {
            EmptyView()
        }
    }
}


