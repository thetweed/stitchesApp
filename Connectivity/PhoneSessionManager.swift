//
//  PhoneSessionManager.swift
//  stitchesApp
//
//  Created by Laurie on 2/5/25.
//

import Foundation
import CoreData
import WatchConnectivity

class PhoneSessionManager: NSObject, ObservableObject {
    static let shared = PhoneSessionManager()
    @Published var isReachable = false
    
    private let session: WCSession
    
    override private init() {
            self.session = .default
            super.init()
            
            print("Phone: Initializing PhoneSessionManager")
            if WCSession.isSupported() {
                print("Phone: WCSession is supported, setting up delegate")
                session.delegate = self
                session.activate()
                print("Phone: WCSession activation requested")
            } else {
                print("Phone: WCSession is not supported")
            }
        }
}

extension PhoneSessionManager: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Phone: Session deactivated")
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Phone: Session activation failed with error: \(error.localizedDescription)")
            return
        }
        
        print("Phone: Session activation completed with state: \(activationState.rawValue)")
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
            print("Phone: Initial reachability state: \(self.isReachable)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            print("Phone: Received message: \(message)")
            if let type = message["type"] as? String {
                switch type {
                case "requestCounters":
                    print("Phone: Received request for counters")
                    self.sendCountersToWatch()
                    replyHandler(["status": "processing"])
                case "stitchCount":
                    print("Phone: Received stitch count update")
                    if let count = message["count"] as? Int,
                       let counterIdString = message["counterId"] as? String,
                       let counterId = UUID(uuidString: counterIdString) {
                        self.updateCounter(id: counterId, count: count)
                        replyHandler(["status": "updated"])
                    } else {
                        print("Phone: Invalid stitch count data received")
                        replyHandler(["status": "error", "message": "Invalid data"])
                    }
                default:
                    print("Phone: Unknown message type: \(type)")
                    replyHandler(["status": "unknown type"])
                }
            }
        }
    }
    
    private func updateCounter(id: UUID, count: Int) {
        let context = CoreDataManager.shared.viewContext
        let request = NSFetchRequest<Counter>(entityName: "Counter")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let counter = try context.fetch(request).first {
                counter.currentCount = Int32(count)
                counter.lastModified = Date()
                try context.save()
            }
        } catch {
            print("Error updating counter: \(error)")
        }
    }
}

extension PhoneSessionManager {
    func sendCountersToWatch() {
        guard session.isReachable else {
            print("Phone: Watch is not reachable")
            return
        }
        
        let context = CoreDataManager.shared.viewContext
        let request = NSFetchRequest<Counter>(entityName: "Counter")
        request.predicate = NSPredicate(format: "project != nil")  // Only send counters with projects
        
        do {
            let counters = try context.fetch(request)
            print("Phone: Found \(counters.count) counters to send")
            
            let countersData = counters.map { counter -> [String: Any] in
                let data = [
                    "id": counter.id.uuidString,
                    "name": counter.name,
                    "currentCount": counter.currentCount,
                    "targetCount": counter.targetCount,
                    "counterType": counter.counterType,
                    "notes": counter.notes ?? "",
                    "lastModified": counter.lastModified,
                    "projectId": counter.project?.id.uuidString ?? "",
                    "projectName": counter.project?.name ?? ""
                ] as [String: Any]
                print("Phone: Preparing counter data: \(counter.name) for project: \(counter.project?.name ?? "no project")")
                return data
            }
            
            let message = [
                "type": "countersData",
                "counters": countersData
            ] as [String: Any]
            
            print("Phone: Sending \(countersData.count) counters to watch")
            session.sendMessage(message, replyHandler: { reply in
                print("Phone: Counters data sent successfully, reply: \(reply)")
            }, errorHandler: { error in
                print("Phone: Error sending counters data: \(error.localizedDescription)")
            })
        } catch {
            print("Phone: Error fetching counters: \(error)")
        }
    }
}
