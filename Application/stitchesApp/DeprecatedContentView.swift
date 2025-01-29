//
//  DeprecatedContentView.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//
/*
 import SwiftUI
 impore CoreData
 
 struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var path = NavigationPath()
    @State private var selectedItem: Sidebar.NavigationItem? = .dashboard
    
    var body: some View {
        NavigationSplitView {
            Sidebar(selection: $selectedItem)
        } detail: {
            Group {
                switch selectedItem {
                case .dashboard:
                    DashboardView()
                case .projects:
                    ProjectListView(viewContext: viewContext)
                case .counters:
                    CountersView()
                case .yarn:
                    YarnbookView()
                case .album:
                    AlbumView()
                case .none:
                    DashboardView() // Default to dashboard if nothing selected
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                }
            }
        }
    }
}

struct Sidebar: View {
    @Binding var selection: NavigationItem?
    
    enum NavigationItem: Hashable {
        case dashboard
        case projects
        case counters
        case yarn
        case album
    }
    
    var body: some View {
        List(selection: $selection) {
            NavigationLink(value: NavigationItem.dashboard) {
                Label("Dashboard", systemImage: "square.grid.2x2.fill")
            }
            
            NavigationLink(value: NavigationItem.projects) {
                Label("Projects", systemImage: "square.stack.3d.up.fill")
            }
            
            NavigationLink(value: NavigationItem.counters) {
                Label("Counters", systemImage: "number.circle.fill")
            }
            
            NavigationLink(value: NavigationItem.yarn) {
                Label("Yarn Collection", systemImage: "tornado")
            }
            
            NavigationLink(value: NavigationItem.album) {
                Label("Project Album", systemImage: "photo.stack")
            }
        }
        .navigationTitle("Stitches")
    }
}*/
