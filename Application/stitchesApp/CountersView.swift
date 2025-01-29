//
//  CountersView.swift
//  stitchesApp
//
//  Created by Laurie on 1/15/25.
//

import SwiftUI
import CoreData



struct CountersView: View {
    var body: some View {
        BasicStitchCounterView(
            context: CoreDataManager.shared.container.viewContext
        )
    }
}

#Preview {
    Previewing(\.sampleCounter) { counter in
        CountersView()
    }
}
