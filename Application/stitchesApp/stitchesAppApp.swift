//
//  stitchesAppApp.swift
//  stitchesApp
//
//  Created by Laurie on 12/18/24.
//

import SwiftUI
import CoreData

@main
struct stitchesAppApp: App {
    let persistenceController = CoreDataManager.shared
    @State private var isLoading = true

    var body: some Scene {
            WindowGroup {
                ZStack {
                    if isLoading {
                        SplashScreenView()
                    } else {
                        ContentView()
                            .environment(\.managedObjectContext, CoreDataManager.shared.container.viewContext)
                    }
                }
                .onAppear {
                    // Simulate loading time or perform actual initialization
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isLoading = false
                        }
                    }
                }
            }
        }
}

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color("darkPurple") // Define this in your assets
                .ignoresSafeArea()
            
            VStack {
                Image("logo") // Add this to your assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                ProgressView()
                    .padding(.top)
            }
        }
    }
}
