//
//  CollectibleRow.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Claude 4 on 5/24/25.
//

import SwiftUI

/// Enhanced CollectibleRow for better visual presentation
struct CollectibleRow<T: CollectibleItem>: View {
    let item: T
    let category: Category
    
    var body: some View {
        HStack {
            // Category icon with colored background
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: category.symbolName)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                
                // Category-specific details
                if let fossil = item as? Fossil, let part = fossil.part {
                    Text(part)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else if let bug = item as? Bug, let season = bug.season {
                    Text("Season: \(season)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else if let fish = item as? Fish {
                    Text("Season: \(fish.season)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else if let art = item as? Art {
                    Text("Based on: \(art.basedOn)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Enhanced donation indicator
            Image(systemName: item.isDonated ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.isDonated ? .green : .gray)
                .font(.title3)
        }
        .padding(.vertical, 8)
    }
}
