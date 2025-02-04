//
//  CounterRowView.swift
//  stitchesApp
//
//  Created by Laurie on 1/28/25.
//

import SwiftUI
import CoreData

/*struct CounterRowView: View {
    @ObservedObject var counter: Counter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(counter.name)
                    .font(.headline)
                
                Spacer()
                
                Text("\(counter.currentCount)/\(counter.targetCount)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Label(counter.counterType.capitalized, systemImage: counterTypeIcon)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if let notes = counter.notes, !notes.isEmpty {
                    Text("•")
                        .foregroundStyle(.secondary)
                    Text("Has Notes")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            if counter.targetCount > 0 {
                ProgressView(
                    value: min(Double(counter.currentCount), Double(counter.targetCount)),
                    total: Double(counter.targetCount)
                )
                .tint(progressColor)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var counterTypeIcon: String {
        switch counter.counterType {
        case "row":
            return "arrow.left.and.right"
        case "repeat":
            return "arrow.triangle.2.circlepath"
        default:
            return "number"
        }
    }
    
    private var progressColor: Color {
        counter.currentCount >= counter.targetCount ? .green : .blue
    }
}*/

struct CounterRowView: View {
    @ObservedObject var counter: Counter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(counter.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                Text(counterProgress)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Label(counter.counterType.capitalized, systemImage: counterTypeIcon)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if let notes = counter.notes, !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("•")
                        .foregroundStyle(.secondary)
                    Text("Has Notes")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            if counter.targetCount > 0 {
                ProgressView(
                    value: min(Double(counter.currentCount), Double(counter.targetCount)),
                    total: Double(counter.targetCount)
                )
                .tint(progressColor)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var counterProgress: String {
        "\(counter.currentCount)/\(counter.targetCount)"
    }
    
    private var counterTypeIcon: String {
        switch counter.counterType.lowercased() {
        case "row":
            return "arrow.left.and.right"
        case "repeat":
            return "arrow.triangle.2.circlepath"
        default:
            return "number"
        }
    }
    
    private var progressColor: Color {
        if counter.targetCount <= 0 {
            return .blue
        }
        return counter.currentCount >= counter.targetCount ? .green : .blue
    }
}

struct CounterRowView_Previews: PreviewProvider {
    static var previews: some View {
        Previewing(\.sampleCounters) { counters in
            List {
                Section("Basic States") {
                    // Basic counter with progress
                    CounterRowView(counter: counters.inProgress)
                        .previewDisplayName("In Progress Counter")
                    
                    // Completed counter
                    CounterRowView(counter: counters.completed)
                        .previewDisplayName("Completed Counter")
                    
                    // Empty counter
                    CounterRowView(counter: counters.empty)
                        .previewDisplayName("Empty Counter")
                }
                
                Section("Counter Types") {
                    // Row counter
                    CounterRowView(counter: counters.row)
                        .previewDisplayName("Row Counter")
                    
                    // Stitch counter
                    CounterRowView(counter: counters.stitch)
                        .previewDisplayName("Stitch Counter")
                    
                    // Repeat counter
                    CounterRowView(counter: counters.repeat)
                        .previewDisplayName("Repeat Counter")
                }
                
                Section("With Notes") {
                    // Counter with notes
                    CounterRowView(counter: counters.withNotes)
                        .previewDisplayName("Counter with Notes")
                }
            }
            .previewLayout(.sizeThatFits)
        }
    }
}
