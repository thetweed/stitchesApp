//
//  YarnRowView.swift
//  stitchesApp
//
//  Created by Laurie on 1/24/25.
//

import SwiftUI
import CoreData

struct YarnRowView: View {
    let yarn: Yarn
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(yarn.colorName)
                .font(.headline)
            Text(yarn.brand)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
