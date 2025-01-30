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
