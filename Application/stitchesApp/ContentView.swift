//
//  ContentView.swift
//  stitchesApp
//
//  Created by Laurie on 12/18/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Dashboard Tab
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
            
            // Projects Tab
            NavigationStack {
                ProjectListView(viewContext: viewContext)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Projects", systemImage: "square.stack.3d.up.fill")
            }
            .tag(1)
            
            // Counters Tab
            NavigationStack {
                CountersView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Counters", systemImage: "number.circle.fill")
            }
            .tag(2)
            
            // Yarn Tab
            NavigationStack {
                YarnbookView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Yarn", systemImage: "tornado")
            }
            .tag(3)
            
            // Album Tab
            NavigationStack {
                AlbumView()
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Album", systemImage: "photo.stack")
            }
            .tag(4)
        }
        .tint(.blue) // You can customize the accent color
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
