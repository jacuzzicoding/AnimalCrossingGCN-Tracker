//
//  ACColors.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 3/1/25.
//

import SwiftUI

/// Animal Crossing themed colors for use throughout the app
extension Color {
    /// Leaf green color (#6BD38B)
    static let acLeafGreen = Color(red: 107/255, green: 211/255, blue: 139/255)
    
    /// Museum brown color (#B87D4B)
    static let acMuseumBrown = Color(red: 184/255, green: 125/255, blue: 75/255)
    
    /// Ocean blue color (#7ACDF4)
    static let acOceanBlue = Color(red: 122/255, green: 205/255, blue: 244/255)
    
    /// Bell yellow color (#FAD87B)
    static let acBellYellow = Color(red: 250/255, green: 216/255, blue: 123/255)
    
    /// Blathers purple color (#A17AC4)
    static let acBlathersPurple = Color(red: 161/255, green: 122/255, blue: 196/255)
    
    /// Pumpkin orange color (#ED8A33)
    static let acPumpkinOrange = Color(red: 237/255, green: 138/255, blue: 51/255)
    
    /// Winter blue color (#8ABDDE)
    static let acWinterBlue = Color(red: 138/255, green: 189/255, blue: 222/255)
}

/// Extension for hierarchical background styling
extension View {
    /// Applies hierarchical background styling consistent with the app's design
    /// - Parameters:
    ///   - level: The hierarchy level (secondary or tertiary)
    ///   - cornerRadius: Corner radius for the background
    /// - Returns: A view with the appropriate background styling
    @ViewBuilder
    func hierarchicalBackground(level: BackgroundLevel = .secondary, cornerRadius: CGFloat = 10) -> some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            switch level {
            case .secondary:
                self.background(.background.secondary)
                    .cornerRadius(cornerRadius)
            case .tertiary:
                self.background(.background.tertiary)
                    .cornerRadius(cornerRadius)
            }
        } else {
            #if os(iOS)
            switch level {
            case .secondary:
                self.background(Color(uiColor: UIColor.secondarySystemBackground))
                    .cornerRadius(cornerRadius)
            case .tertiary:
                self.background(Color(uiColor: UIColor.tertiarySystemBackground))
                    .cornerRadius(cornerRadius)
            }
            #else
            // For macOS or other platforms
            switch level {
            case .secondary:
                self.background(Color.secondary.opacity(0.2))
                    .cornerRadius(cornerRadius)
            case .tertiary:
                self.background(Color.secondary.opacity(0.1))
                    .cornerRadius(cornerRadius)
            }
            #endif
        }
    }
}

/// Define BackgroundLevel enum
enum BackgroundLevel {
    case secondary
    case tertiary
}
