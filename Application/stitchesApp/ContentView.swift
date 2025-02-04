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
        mainTabView
            .onAppear {
                print("ContentView appeared")
                do {
                    let projectCount = try viewContext.count(for: NSFetchRequest(entityName: "Project"))
                    let yarnCount = try viewContext.count(for: NSFetchRequest(entityName: "Yarn"))
                    let counterCount = try viewContext.count(for: NSFetchRequest(entityName: "Counter"))
                    
                    print("Current database state:")
                    print("- Projects: \(projectCount)")
                    print("- Yarns: \(yarnCount)")
                    print("- Counters: \(counterCount)")
                } catch {
                    print("Error checking counts: \(error)")
                }
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
        .onChange(of: selectedTab) {
            CoreDataManager.shared.saveContext()
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
