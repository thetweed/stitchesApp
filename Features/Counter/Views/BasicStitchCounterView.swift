//
//  BasicStitchCounterView.swift
//  stitchesApp
//
//  Created by Laurie on 1/15/25.
//

import SwiftUI
import CoreData

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
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Target Count", systemImage: "target")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        HStack {
                            TextField("Set target", value: $viewModel.targetCount, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)
                            
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
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    )

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
                Button("Done") {
                    viewModel.saveCount()
                    showingSaveConfirmation = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        dismiss()
                    }
                }
            }
        }
        .overlay {
            if showingSaveConfirmation {
                SaveConfirmationView()
            }
        }
    }
    
    private var progressColor: Color {
        viewModel.currentCount >= viewModel.targetCount ? .green : .blue
    }
}

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
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .transition(.scale.combined(with: .opacity))
    }
}

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

#Preview {
    Previewing(\.sampleCounter) { counter in
        BasicStitchCounterView(
            context: CoreDataManager.shared.container.viewContext,
            counter: counter
        )
    }
}
