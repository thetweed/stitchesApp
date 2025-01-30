//
//  ContentView.swift
//  stitchesApp
//
//  Created by Laurie on 12/18/24.
//

import SwiftUI
import CoreData

/*struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTab = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            NavigationStack {
                DashboardView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gear")
                            }
                        }
                    }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)
            
            NavigationStack {
                ProjectListView(viewContext: viewContext)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Projects", systemImage: "square.stack.3d.up.fill")
            }
            .tag(1)
            
            NavigationStack {
                CountersView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Counters", systemImage: "number.circle.fill")
            }
            .tag(2)
            
            NavigationStack {
                YarnbookView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Yarn", systemImage: "tornado")
            }
            .tag(3)
            
            NavigationStack {
                AlbumView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Album", systemImage: "photo.stack")
            }
            .tag(4)
        }
        .tint(.accentColor) //accent color
        .scrollContentBackground(.hidden)
    }
}*/

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTab = 0
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
            } else {
                mainTabView
            }
        }
        .task {
            await loadInitialData()
        }
    }
    
    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DashboardView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gear")
                            }
                        }
                    }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)
            
            NavigationStack {
                ProjectListView(viewContext: viewContext)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Projects", systemImage: "square.stack.3d.up.fill")
            }
            .tag(1)
            
            NavigationStack {
                CountersView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Counters", systemImage: "number.circle.fill")
            }
            .tag(2)
            
            NavigationStack {
                YarnbookView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Yarn", systemImage: "tornado")
            }
            .tag(3)
            
            NavigationStack {
                AlbumView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Album", systemImage: "photo.stack")
            }
            .tag(4)
        }
        .tint(.accentColor)
        .scrollContentBackground(.hidden)
    }
    
    private func loadInitialData() async {
        do {
            let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
            _ = try viewContext.fetch(fetchRequest)
            
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            await MainActor.run {
                isLoading = false
            }
        } catch {
            print("Error loading initial data: \(error)")
            await MainActor.run {
                isLoading = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let context = CoreDataManager.shared.container.viewContext
    
    static var previews: some View {
        let sampleData = PreviewingData()
        let _ = sampleData.sampleProjects(context)
        let _ = sampleData.sampleYarns(context)
        return ContentView()
            .environment(\.managedObjectContext, context)
    }
}
