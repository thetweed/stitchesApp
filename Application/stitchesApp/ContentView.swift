//
//  ContentView.swift
//  stitchesApp
//
//  Created by Laurie on 12/18/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "circle.circle.fill")
                }
                .tag(0)
            
            ProjectsView()
                .tabItem {
                    Label("Projects", systemImage: "pin.circle.fill")
                }
                .tag(1)
            
            CountersView()
                .tabItem {
                    Label("Counters", systemImage: "link.circle.fill")
                }
                .tag(2)

            YarnbookView()
                .tabItem {
                    Label("Yarnbook", systemImage: "tornado.circle.fill")
                }
                .tag(3)
            
           /* SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "line.3.horizontal")
                }
                .tag(3)*/
        }
    }
}

struct HomeView: View {
    var body: some View{
        /*NavigationView {
            Text("Home")
                .navigationTitle("Home")
        }*/
        VStack {
            Text("StitchCounter")
                .padding(.top, 50)
            Image("logo")
                .resizable()
                .padding(.bottom, 100)
                .padding(.horizontal, 100)
            Text("Settings")
            SettingsView()
        }
        
    }
}

// Preview provider
#Preview {
    ContentView()
}
