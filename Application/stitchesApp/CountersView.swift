//
//  CountersView.swift
//  stitchesApp
//
//  Created by Laurie on 1/15/25.
//

import SwiftUI
import CoreData



struct CountersView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        CounterHomeView()
            .environment(\.managedObjectContext, viewContext)
    }
}

#Preview {
    Previewing(\.sampleCounter) { counter in
        CountersView()
    }
}
