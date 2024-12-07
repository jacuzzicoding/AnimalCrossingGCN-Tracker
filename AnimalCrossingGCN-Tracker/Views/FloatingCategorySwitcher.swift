//
// FloatingCategorySwitcher.swift
//
import Foundation
import SwiftUI
import SwiftData

struct FloatingCategorySwitcher: View { //new file for the floating category switcher
    @EnvironmentObject var categoryManager: CategoryManager
    
    var body: some View {
        ZStack { //using ZStack now to ensure the switcher floats on top and is interactable
#if os(macOS)
            RoundedRectangle(cornerRadius: 16)
                .fill(Material.regular.opacity(0.8))
                .frame(width: 300, height: 100)
                .allowsHitTesting(false)
#else //ios
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
                .frame(width: 310, height: 105)
#endif
            //buttons layer
            HStack(spacing: 16) {
                ForEach(Category.allCases, id: \.self) { category in
                    Button {
                        debugPrint("Button pressed for category: \(category)")
                        withAnimation(.easeInOut(duration: 0.3)) {
                            categoryManager.selectedCategory = category
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
                        .background(categoryManager.selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(categoryManager.selectedCategory == category ? .white : .primary)
                        .cornerRadius(10)
                    }
//#if os(macOS)
                    .buttonStyle(PlainButtonStyle())
                    .focusable(false)
//#endif
                }
            }
            .padding()
        }
        .frame(maxWidth: 400)
        .shadow(radius: 5)
    }
}
