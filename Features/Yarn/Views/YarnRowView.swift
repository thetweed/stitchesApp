//
//  YarnRowView.swift
//  stitchesApp
//
//  Created by Laurie on 1/24/25.
//

import SwiftUI
import CoreData

struct YarnRowView: View {
    @ObservedObject var yarn: Yarn
    var showDetails: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Yarn Name and Brand
            HStack(alignment: .center, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(yarn.colorName)
                        .font(.headline)
                    Text(yarn.brand)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if !yarn.projectsArray.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "knot")
                            .font(.caption)
                        Text("In Use")
                            .font(.caption)
                    }
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.15))
                    )
                }
            }
            
            if showDetails {
                // Yarn Details Row
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "ruler")
                            .font(.caption)
                        Text("\(Int(yarn.remainingYardage))y")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                    
                    if !yarn.projectsArray.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "folder")
                            Text("\(yarn.projectsArray.count) project\(yarn.projectsArray.count == 1 ? "" : "s")")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}
