//
// FloatingCategorySwitcher.swift
//
import Foundation
import SwiftUI
import SwiftData
import Charts

// Import analytics components

struct FloatingCategorySwitcher: View { //new file for the floating category switcher
    @EnvironmentObject var categoryManager: CategoryManager
    
    var body: some View {
        ZStack { //using ZStack now to ensure the switcher floats on top and is interactable
#if os(macOS)
            RoundedRectangle(cornerRadius: 16)
                .fill(Material.regular.opacity(0.8))
                .frame(width: 370, height: 100)
                .allowsHitTesting(false)
#else //ios
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
                .frame(width: 380, height: 105)
#endif
            //buttons layer
            HStack(spacing: 12) {
                // Standard category buttons
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
                        .background(categoryManager.selectedCategory == category && !categoryManager.showingAnalytics ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(categoryManager.selectedCategory == category && !categoryManager.showingAnalytics ? .white : .primary)
                        .cornerRadius(10)
                    }
                }
                
                // Analytics button
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
                    .background(categoryManager.showingAnalytics ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(categoryManager.showingAnalytics ? .white : .primary)
                    .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                .focusable(false)
            }
            .padding()
        }
        .frame(maxWidth: 400)
        .shadow(radius: 5)
    }
}
