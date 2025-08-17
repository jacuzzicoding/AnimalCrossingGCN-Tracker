//
// FloatingCategorySwitcher.swift
//
import Foundation
import SwiftUI
import SwiftData
import Charts

struct FloatingCategorySwitcher: View {
    @EnvironmentObject var categoryManager: CategoryManager
    
    var body: some View {
        ZStack {
            // Background with increased width for the analytics button
#if os(macOS)
            RoundedRectangle(cornerRadius: 16)
                .fill(Material.regular.opacity(0.8))
                .frame(width: 450, height: 100)  // Increased width from 370 to 450
                .allowsHitTesting(false)
#else //iOS
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
                .frame(width: 460, height: 105)  // Increased width from 380 to 460
#endif
            
            // Main container for buttons - added alignment and spacing control
            HStack(alignment: .center, spacing: 16) {  // Increased spacing from 12 to 16
                // Standard category buttons in a scrollable container for smaller screens
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {  // Increased spacing for better separation
                        ForEach(Category.allCases, id: \.self) { category in
                            Button {
                                debugPrint("Button pressed for category: \(category)")
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    categoryManager.switchCategory(category)
                                }
                                debugPrint("Button action completed for category: \(category)")
                            } label: {
                                VStack {
                                    Image(systemName: category.symbolName)
                                        .font(.headline)
                                    Text(category.rawValue)
                                        .font(.caption)
                                }
                                .padding()
                                .frame(minWidth: 70, minHeight: 70)  // Added minimum size constraint
                                .background(categoryManager.selectedCategory == category && !categoryManager.showingAnalytics ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(categoryManager.selectedCategory == category && !categoryManager.showingAnalytics ? .white : .primary)
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
                
                // Divider between category buttons and Analytics button
                Divider()
                    .frame(height: 40)
                
                // Analytics button - now with fixed size
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        categoryManager.showAnalytics()
                    }
                } label: {
                    VStack {
                        Image(systemName: "chart.bar.fill")
                            .font(.headline)
                        Text("Analytics")
                            .font(.caption)
                    }
                    .padding()
                    .frame(minWidth: 80, minHeight: 70)  // Fixed size that won't get compressed
                    .background(categoryManager.showingAnalytics ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(categoryManager.showingAnalytics ? .white : .primary)
                    .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                .focusable(false)
            }
            .padding(.horizontal, 8)  // Reduced from default padding to fit more buttons
        }
        .frame(maxWidth: 470)  // Increased from 400 to 470
        .shadow(radius: 5)
        .zIndex(10)  // Ensure it stays on top of other UI elements
    }
}
