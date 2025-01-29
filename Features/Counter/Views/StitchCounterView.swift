//
//  StitchCounterView.swift
//  stitchesApp
//
//  Created by Laurie on 1/28/25.
//

import SwiftUI
import CoreData

/*struct StitchCounterView: View {
   @StateObject private var viewModel: StitchCounterViewModel
   @Environment(\.colorScheme) private var colorScheme
   
    init(context: NSManagedObjectContext, project: Project? = nil, counter: Counter? = nil) {
        _viewModel = StateObject(wrappedValue:
            StitchCounterViewModel(context: context, project: project, counter: counter)
        )
    }
   
   var body: some View {
       VStack(spacing: 24) {
           counterDisplay
           targetDisplay
           controlButtons
           resetButton
           targetSettings
       }
       .padding()
   }
   
   private var counterDisplay: some View {
       Text("Current Count: \(viewModel.currentCount)")
           .font(.system(.title2, design: .rounded))
           .bold()
           .padding()
           .frame(maxWidth: .infinity)
           .background(
               RoundedRectangle(cornerRadius: 12)
                   .fill(Color(.systemBackground))
                   .shadow(radius: 2)
           )
   }
   
   private var targetDisplay: some View {
       Group {
           if viewModel.targetCount > 0 {
               VStack(spacing: 4) {
                   Text("\(viewModel.currentCount)/\(viewModel.targetCount)")
                       .font(.title3)
                       .bold()
                   
                   ProgressView(
                       value: Double(viewModel.currentCount),
                       total: Double(viewModel.targetCount)
                   )
                   .tint(progressColor)
               }
               .padding()
               .background(
                   RoundedRectangle(cornerRadius: 12)
                       .fill(Color(.systemBackground))
                       .shadow(radius: 2)
               )
           }
       }
   }
   
   private var controlButtons: some View {
       HStack(spacing: 40) {
           Button(action: viewModel.undoStitch) {
               Image(systemName: "minus.circle.fill")
                   .font(.system(size: 44))
                   .foregroundColor(.red)
           }
           .disabled(viewModel.currentCount <= 0)
           
           Button(action: viewModel.count) {
               Image(systemName: "plus.circle.fill")
                   .font(.system(size: 44))
                   .foregroundColor(.green)
           }
       }
       .padding()
       .background(
           RoundedRectangle(cornerRadius: 12)
               .fill(Color(.systemBackground))
               .shadow(radius: 2)
       )
   }
   
   private var resetButton: some View {
       Button(action: { viewModel.resetCount() }) {
           Label("Reset Count", systemImage: "arrow.counterclockwise")
               .font(.headline)
               .padding()
               .frame(maxWidth: .infinity)
               .background(
                   RoundedRectangle(cornerRadius: 12)
                       .fill(Color(.systemBackground))
                       .shadow(radius: 2)
               )
       }
       .foregroundColor(.primary)
   }
   
   private var targetSettings: some View {
       VStack(spacing: 12) {
           Text("Target Count")
               .font(.headline)
           
           HStack {
               TextField("Set target", value: $viewModel.targetCount, format: .number)
                   .textFieldStyle(.roundedBorder)
                   .keyboardType(.numberPad)
                   .frame(width: 100)
               
               Button("Set") {
                   viewModel.setTargetCount(viewModel.targetCount)
               }
               .buttonStyle(.borderedProminent)
           }
       }
       .padding()
       .background(
           RoundedRectangle(cornerRadius: 12)
               .fill(Color(.systemBackground))
               .shadow(radius: 2)
       )
   }
   
   private var progressColor: Color {
       if viewModel.currentCount >= viewModel.targetCount {
           return .green
       }
       return .blue
   }
}

*/
