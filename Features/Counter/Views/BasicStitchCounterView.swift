//
//  BasicStitchCounterView.swift
//  stitchesApp
//
//  Created by Laurie on 1/15/25.
//

import SwiftUI
import CoreData

// MARK: - Main View
struct BasicStitchCounterView: View {
    @StateObject private var viewModel: StitchCounterViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var showingSaveConfirmation = false
    
    init(context: NSManagedObjectContext, counter: Counter? = nil) {
        _viewModel = StateObject(wrappedValue:
            StitchCounterViewModel(context: context, counter: counter)
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                        .frame(height: geometry.size.height * 0.1)
                    
                    CounterDisplayView(viewModel: viewModel)
                    CounterControlsView(viewModel: viewModel)
                    TargetCountInputView(viewModel: viewModel)
                    ResetButtonView(viewModel: viewModel)
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.1)
                }
                .padding()
                .frame(minHeight: geometry.size.height)
            }
        }
        .navigationTitle(viewModel.counterName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                SaveButton(viewModel: viewModel, showingSaveConfirmation: $showingSaveConfirmation, dismiss: dismiss)
            }
        }
        .overlay {
            if showingSaveConfirmation {
                SaveConfirmationView()
            }
        }
    }
}

// MARK: - Counter Display Component
struct CounterDisplayView: View {
    @ObservedObject var viewModel: StitchCounterViewModel
    
    private var progressColor: Color {
        viewModel.currentCount >= viewModel.targetCount ? .green : .blue
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Label("Stitch Counter", systemImage: "number.circle.fill")
                .font(.headline)
                .foregroundStyle(.blue)
            
            Text("\(viewModel.currentCount)")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            
            if viewModel.targetCount > 0 {
                Text("\(viewModel.currentCount)/\(viewModel.targetCount)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                ProgressView(
                    value: Double(viewModel.currentCount),
                    total: Double(viewModel.targetCount)
                )
                .tint(progressColor)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

// MARK: - Counter Controls Component
struct CounterControlsView: View {
    @ObservedObject var viewModel: StitchCounterViewModel
    
    var body: some View {
        HStack(spacing: 40) {
            CounterButton(
                action: viewModel.undoStitch,
                icon: "minus.circle.fill",
                color: .red,
                isDisabled: viewModel.currentCount <= 0
            )
            
            CounterButton(
                action: viewModel.count,
                icon: "plus.circle.fill",
                color: .green,
                isDisabled: false
            )
        }
        .padding(.vertical, 20)
    }
}

// MARK: - Target Count Input Component
struct TargetCountInputView: View {
    @ObservedObject var viewModel: StitchCounterViewModel
    @State private var tempTargetCount: Int
    
    init(viewModel: StitchCounterViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self._tempTargetCount = State(initialValue: viewModel.targetCount)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Target Count", systemImage: "target")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            HStack {
                TextField("Set target", value: $tempTargetCount, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                
                Button("Set") {
                    viewModel.targetCount = tempTargetCount
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

// MARK: - Reset Button Component
struct ResetButtonView: View {
    @ObservedObject var viewModel: StitchCounterViewModel
    
    var body: some View {
        Button(action: { viewModel.resetCount() }) {
            Label("Reset Counter", systemImage: "arrow.counterclockwise")
                .font(.headline)
                .foregroundStyle(.primary)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                )
        }
    }
}

// MARK: - Save Button Component
struct SaveButton: View {
    @ObservedObject var viewModel: StitchCounterViewModel
    @Binding var showingSaveConfirmation: Bool
    var dismiss: DismissAction
    
    var body: some View {
        Button("Done") {
            // Data is already saved through property observers
            showingSaveConfirmation = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                dismiss()
            }
        }
    }
}

// MARK: - Save Confirmation Component
struct SaveConfirmationView: View {
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
            Text("Saved")
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .transition(.scale.combined(with: .opacity))
    }
}

// MARK: - Counter Button Component
struct CounterButton: View {
    let action: () -> Void
    let icon: String
    let color: Color
    let isDisabled: Bool
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 56))
                .foregroundStyle(isDisabled ? .gray : color)
        }
        .disabled(isDisabled)
    }
}

