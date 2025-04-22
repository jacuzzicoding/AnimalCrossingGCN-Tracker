//
//  ProgressBar.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 4/21/25.
//
//  This file implements a reusable progress bar component for showing
//  completion progress across the app.

import SwiftUI

/// A reusable progress indicator with customizable appearance
struct ProgressBar: View {
    let value: Double
    let label: String?
    var color: Color = .acLeafGreen
    var height: CGFloat = 20
    var showPercentage: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                Rectangle()
                    .frame(width: geometry.size.width, height: height)
                    .opacity(0.2)
                    .foregroundColor(color)
                    .cornerRadius(height / 2)
                
                // Fill
                Rectangle()
                    .frame(width: min(CGFloat(value) * geometry.size.width, geometry.size.width), height: height)
                    .foregroundColor(color)
                    .cornerRadius(height / 2)
                    .animation(.easeInOut, value: value)
                
                // Percentage and/or label
                HStack {
                    if let label = label {
                        Text(label)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                    }
                    
                    Spacer()
                    
                    if showPercentage {
                        Text("\(Int(value * 100))%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.trailing, 10)
                    }
                }
            }
        }
        .frame(height: height)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label ?? "Progress"): \(Int(value * 100))%")
        .accessibilityValue("\(Int(value * 100)) percent")
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ProgressBar(
                value: 0.75,
                label: "Fossils"
            )
            
            ProgressBar(
                value: 0.3,
                label: "Bugs",
                color: .green,
                height: 15
            )
            
            ProgressBar(
                value: 0.5,
                label: "Fish",
                color: .acOceanBlue,
                height: 25,
                showPercentage: false
            )
            
            ProgressBar(
                value: 0.9,
                label: nil,
                color: .acBlathersPurple
            )
        }
        .padding()
    }
}
