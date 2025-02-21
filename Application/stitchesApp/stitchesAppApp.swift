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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let coreDataManager = CoreDataManager.shared
    @State private var isLoading = true
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoading {
                    SplashScreenView()
                } else {
                    ContentView()
                        .environment(\.managedObjectContext, coreDataManager.viewContext)
                        .onChange(of: scenePhase) { oldPhase, newPhase in
                            if newPhase == .inactive || newPhase == .background {
                                print("App moving to \(newPhase) - attempting to save")
                                coreDataManager.saveContext()
                            }
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                            print("Application will resign active - attempting to save")
                            coreDataManager.saveContext()
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                            print("Application entering background - attempting to save")
                            coreDataManager.saveContext()
                        }
                }
            }
            .task {
                do {
                    print("Beginning app initialization...")
                    let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
                    let projects = try coreDataManager.viewContext.fetch(fetchRequest)
                    print("Found \(projects.count) projects during initialization")
                    
                    try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
                    await MainActor.run {
                        withAnimation {
                            isLoading = false
                        }
                    }
                } catch {
                    print("Initialization error: \(error)")
                    await MainActor.run {
                        withAnimation {
                            isLoading = false
                        }
                    }
                }
            }
        }
    }
}


struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color("darkPurple")
                .ignoresSafeArea()
            
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                ProgressView()
                    .padding(.top)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let phoneSessionManager = PhoneSessionManager.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Phone: App did finish launching")
        return true
    }
}
