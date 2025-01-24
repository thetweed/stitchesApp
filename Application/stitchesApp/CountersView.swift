//
//  CountersView.swift
//  stitchesApp
//
//  Created by Laurie on 1/15/25.
//

import SwiftUI
import CoreData

struct CountersView: View {
    var body: some View{
        /*NavigationView {
         Text("Counters")
         .navigationTitle("My Counters")
         }*/
        StitchCounterView(context: CoreDataManager.shared.container.viewContext)
    }
}

