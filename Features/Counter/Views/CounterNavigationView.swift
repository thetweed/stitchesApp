//
//  CounterNavigationView.swift
//  stitchesApp
//
//  Created by Laurie on 1/29/25.
//

import SwiftUI
import CoreData

/*struct CounterNavigationView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var project: Project
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Default counter that doesn't persist
                StitchCounterView(context: context)
                    .padding()
                
                Divider()
                
                // Project Counters Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Project Counters")
                        .font(.headline)
                    
                    NavigationLink {
                        CounterListView(project: project)
                    } label: {
                        Label("View All Counters", systemImage: "list.bullet")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    
                    Button {
                        // Present counter setup sheet
                        // Implementation below
                    } label: {
                        Label("Add New Counter", systemImage: "plus.circle")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("Stitch Counter")
        }
    }
}
*/
