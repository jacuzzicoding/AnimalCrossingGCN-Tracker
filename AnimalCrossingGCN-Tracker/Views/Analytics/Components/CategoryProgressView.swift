//
//  CategoryProgressView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 11/11/25.
//

import SwiftUI
import SwiftData

// Helper view for category progress
struct CategoryProgressView: View {
    let label: String
    let progress: Double
    let donated: Int
    let total: Int
    let color: Color

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .bold()
            }

            ProgressView(value: progress)
                .tint(color)

            Text("\(donated) of \(total) donated")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
