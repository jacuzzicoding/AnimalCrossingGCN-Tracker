//
//  ActivityItem.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 4/21/25.
//
//  This file implements a reusable activity item component for displaying
//  recent activity entries.

import SwiftUI

/// Individual activity entry component
struct ActivityItem: View {
    let title: String
    let time: String
    let color: Color
    var showDivider: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("◆")
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
            
            if showDivider {
                Divider()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(time)")
    }
}

struct ActivityItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ActivityItem(
                title: "T-Rex Skull",
                time: "Just now",
                color: .acMuseumBrown
            )
            
            ActivityItem(
                title: "Common Butterfly",
                time: "2 hours ago",
                color: .green
            )
            
            ActivityItem(
                title: "Sea Bass",
                time: "Yesterday",
                color: .acOceanBlue
            )
            
            ActivityItem(
                title: "Amazing Painting",
                time: "2 days ago",
                color: .acBlathersPurple,
                showDivider: false
            )
        }
        .padding()
        .background(Color.acBellYellow.opacity(0.2))
        .cornerRadius(10)
        .padding()
    }
}
