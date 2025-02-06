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
    @Published var stitchCount: Int = 0
    
    // Threshold for detecting a stitch motion
    private let motionThreshold: Double = 0.5
    
    init() {
        setupMotionDetection()
    }
    
    private func setupMotionDetection() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
                guard let data = data, error == nil else { return }
                
                // Basic motion detection algorithm
                // You'll need to refine this based on actual knitting motion patterns
                if abs(data.acceleration.x) > self?.motionThreshold ?? 0 {
                    self?.stitchCount += 1
                }
            }
        }
    }
    
    func stopMotionDetection() {
        motionManager.stopAccelerometerUpdates()
    }
}
