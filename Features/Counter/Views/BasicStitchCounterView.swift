//
//  BasicStitchCounterView.swift
//  stitchesApp
//
//  Created by Laurie on 1/15/25.
//

import SwiftUI
import CoreData

struct StitchCounterView: View {
    @StateObject private var viewModel: StitchCounterViewModel
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: StitchCounterViewModel(context: context))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Stitch Count: \(viewModel.currentCount)")
                .font(.title3)
                .padding()
            
            if viewModel.targetCount > 0 {
                Text("Target: \(viewModel.currentCount)/\(viewModel.targetCount)")
                    .font(.headline)
                    .foregroundColor(viewModel.currentCount >= viewModel.targetCount ? .green : .primary)
            }
            
            HStack(spacing: 30) {
                Button(action: viewModel.undoStitch) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                }
                
                Button(action: viewModel.count) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                }
            }
            
            Button("Reset Count") {
                viewModel.resetCount()
            }
            .padding()
            
            HStack {
                Text("Set Target:")
                TextField("Target Count", value: $viewModel.targetCount, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 100)
                Button("Set") {
                    viewModel.setTargetCount(viewModel.targetCount)
                }
            }
            .padding(.horizontal)
        }
    }
}
