//
//  WatchSessionManager.swift
//  stitchesApp
//
//  Created by Laurie on 2/5/25.
//

import Foundation
import WatchConnectivity
import CoreData

class WatchSessionManager: NSObject, ObservableObject {
    static let shared = WatchSessionManager()
    
    @Published var isReachable = false
    @Published var isSessionActive = false
    @Published var counters: [Counter] = []
    
    let session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        
        if WCSession.isSupported() {
            print("Watch: WCSession is supported, setting up delegate")
            session.delegate = self
            session.activate()
            print("Watch: WCSession activation requested")
        } else {
            print("Watch: WCSession is not supported")
        }
    }
    
    func sendStitchCount(_ count: Int, forCounter counter: Counter) {
        guard session.isReachable else {
            print("iPhone is not reachable")
            return
        }
        
        let message = [
            "type": "stitchCount",
            "count": count,
            "counterId": counter.id.uuidString
        ] as [String: Any]
        
        session.sendMessage(message, replyHandler: { reply in
            print("Message sent successfully: \(reply)")
        }, errorHandler: { error in
            print("Error sending message: \(error.localizedDescription)")
        })
    }
    
    func requestCounters() {
        print("Watch: Attempting to request counters")
        print("Watch: Session active: \(session.activationState == .activated)")
        print("Watch: Session reachable: \(session.isReachable)")
        
        guard session.activationState == .activated else {
            print("Watch: Session not yet activated, waiting...")
            // Wait briefly and try again
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.requestCounters()
            }
            return
        }
        
        guard session.isReachable else {
            print("Watch: iPhone is not reachable")
            return
        }
        
        print("Watch: Sending request for counters")
        let message = ["type": "requestCounters"]
        session.sendMessage(message, replyHandler: { reply in
            print("Watch: Counter request sent, reply received: \(reply)")
        }, errorHandler: { error in
            print("Watch: Error requesting counters: \(error.localizedDescription)")
        })
    }
        
    private func updateOrCreateCounter(from data: [String: Any], in context: NSManagedObjectContext) {
        guard let idString = data["id"] as? String,
              let id = UUID(uuidString: idString) else {
            print("Watch: Invalid counter ID data")
            return
        }
        
        print("Watch: Processing counter with ID: \(idString)")
        
        let request = NSFetchRequest<Counter>(entityName: "Counter")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let counter: Counter
            if let existing = try context.fetch(request).first {
                counter = existing
                print("Watch: Updating existing counter: \(existing.name)")
            } else {
                counter = Counter(context: context)
                counter.id = id
                print("Watch: Creating new counter")
            }
            
            // Update counter properties
            counter.name = data["name"] as? String ?? ""
            counter.currentCount = data["currentCount"] as? Int32 ?? 0
            counter.targetCount = data["targetCount"] as? Int32 ?? 0
            counter.counterType = data["counterType"] as? String ?? ""
            counter.notes = data["notes"] as? String
            if let lastModified = data["lastModified"] as? Date {
                counter.lastModified = lastModified
            }
            
            // Handle project relationship
            if let projectIdString = data["projectId"] as? String,
               let projectId = UUID(uuidString: projectIdString) {
                print("Watch: Looking for project with ID: \(projectIdString)")
                
                let projectRequest = NSFetchRequest<Project>(entityName: "Project")
                projectRequest.predicate = NSPredicate(format: "id == %@", projectId as CVarArg)
                
                if let project = try context.fetch(projectRequest).first {
                    print("Watch: Found existing project: \(project.name)")
                    counter.project = project
                } else {
                    print("Watch: Creating new project")
                    let project = Project.create(
                        in: context,
                        name: data["projectName"] as? String ?? "",
                        projectType: "knitting"
                    )
                    project.id = projectId
                    project.status = "In Progress"  // Set a default status
                    counter.project = project
                    print("Watch: Created new project: \(project.name) with ID: \(project.id)")
                }
            } else {
                print("Watch: No project ID provided for counter")
            }
            
            try context.save()
            print("Watch: Successfully saved counter: \(counter.name) with project: \(counter.project?.name ?? "no project")")
        } catch {
            print("Watch: Error updating/creating counter: \(error)")
        }
    }
}

// MARK: - WCSessionDelegate
extension WatchSessionManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            print("Watch: Session activation completed")
            print("Watch: Activation state: \(activationState.rawValue)")
            if let error = error {
                print("Watch: Activation error: \(error.localizedDescription)")
            }
            
            self.isSessionActive = (activationState == .activated)
            self.isReachable = session.isReachable
            
            if self.isSessionActive {
                print("Watch: Session is now active, requesting counters")
                self.requestCounters()
            }
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            print("Watch: Reachability changed")
            self.isReachable = session.isReachable
            print("Watch: iPhone is now \(self.isReachable ? "reachable" : "not reachable")")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            if let type = message["type"] as? String {
                switch type {
                case "countersData":
                    print("Watch: Received counters data")
                    if let countersData = message["counters"] as? [[String: Any]] {
                        print("Watch: Processing \(countersData.count) counters")
                        let context = WatchCoreDataManager.shared.viewContext
                        
                        for counterData in countersData {
                            self.updateOrCreateCounter(from: counterData, in: context)
                        }
                        
                        // Fetch updated counters
                        let request = NSFetchRequest<Counter>(entityName: "Counter")
                        do {
                            let fetchedCounters = try context.fetch(request)
                            self.counters = fetchedCounters
                            print("Watch: Successfully stored \(self.counters.count) counters")
                        } catch {
                            print("Watch: Error fetching stored counters: \(error)")
                        }
                    } else {
                        print("Watch: Failed to parse counters data")
                    }
                    replyHandler(["status": "received"])
                default:
                    print("Watch: Unknown message type received: \(type)")
                    replyHandler(["status": "unknown type"])
                }
            }
        }
    }
}
