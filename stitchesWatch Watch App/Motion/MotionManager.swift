//
//  MotionManager.swift
//  stitchesApp
//
//  Created by Laurie on 2/5/25.
//

import CoreMotion
import SwiftUI
import CoreData

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published private(set) var stitchCount: Int
    private var isEnabled = true
    
    // Adjusted thresholds
    private let motionThreshold: Double = 1.2  // Increased threshold for more deliberate motion
    private let minimumMotionInterval: TimeInterval = 0.5  // Increased interval to prevent rapid counting
    private var lastMotionTimestamp: Date?
    
    init(initialCount: Int = 0) {
        self.stitchCount = initialCount
        print("Initializing MotionManager with count: \(initialCount)")
    }
    
    func startMotionDetection() {
        print("Starting motion detection")
        guard motionManager.isAccelerometerAvailable else {
            print("Accelerometer not available")
            return
        }
        
        isEnabled = true
        motionManager.accelerometerUpdateInterval = 0.1
        
        let queue = OperationQueue()
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] data, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  self.isEnabled else { return }
            
            let currentTime = Date()
            if let lastTime = self.lastMotionTimestamp,
               currentTime.timeIntervalSince(lastTime) < self.minimumMotionInterval {
                return
            }
            
            // Calculate total acceleration using all axes
            let totalAcceleration = sqrt(
                pow(data.acceleration.x, 2) +
                pow(data.acceleration.y, 2) +
                pow(data.acceleration.z, 2)
            )
            
            // Only count significant movements
            if totalAcceleration > self.motionThreshold {
                self.lastMotionTimestamp = currentTime
                DispatchQueue.main.async {
                    self.stitchCount += 1
                    print("Stitch detected, new count: \(self.stitchCount)")
                }
            }
        }
    }
    
    func stopMotionDetection() {
        print("Stopping motion detection")
        isEnabled = false
        motionManager.stopAccelerometerUpdates()
    }
    
    func updateCount(_ newCount: Int) {
        DispatchQueue.main.async {
            self.stitchCount = newCount
            print("Updated stitch count to: \(newCount)")
        }
    }
}
