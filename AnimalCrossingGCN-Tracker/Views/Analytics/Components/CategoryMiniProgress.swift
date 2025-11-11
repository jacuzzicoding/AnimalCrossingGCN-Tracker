//
//  CategoryMiniProgress.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 11/11/25.
//

import SwiftUI
import SwiftData

// Helper view for mini progress indicators
struct CategoryMiniProgress: View {
    let label: String
    let progress: Double
    let color: Color
    let icon: String

    var body: some View {
        VStack {
            Text(label)
                .font(.caption)

            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 5)
                    .frame(width: 50, height: 50)

                Circle()
                    .trim(from: 0, to: CGFloat(progress))
                    .stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)

                VStack {
                    Image(systemName: icon)
                        .font(.caption)
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 9))
                        .bold()
                }
            }
        }
    }
}
