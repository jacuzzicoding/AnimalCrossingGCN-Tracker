//
//  CategoryIcon.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 4/21/25.
//
//  This file implements a reusable category icon component for consistent
//  visual representation of museum categories.

import SwiftUI

/// A reusable icon component for museum categories
struct CategoryIcon: View {
    let iconName: String
    let color: Color
    var size: CGFloat = 20
    var backgroundColor: Color? = nil
    
    var body: some View {
        ZStack {
            if let backgroundColor = backgroundColor {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: size * 1.8, height: size * 1.8)
            }
            
            Image(systemName: iconName)
                .font(.system(size: size))
                .foregroundColor(color)
        }
    }
}

struct CategoryIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CategoryIcon(
                iconName: "leaf.arrow.circlepath",
                color: .acMuseumBrown
            )
            
            CategoryIcon(
                iconName: "ant.fill",
                color: .green,
                size: 30,
                backgroundColor: .green.opacity(0.2)
            )
            
            CategoryIcon(
                iconName: "fish.fill",
                color: .acOceanBlue,
                size: 24,
                backgroundColor: .blue.opacity(0.1)
            )
            
            CategoryIcon(
                iconName: "paintpalette.fill",
                color: .acBlathersPurple,
                size: 26,
                backgroundColor: .purple.opacity(0.1)
            )
        }
        .padding()
    }
}
