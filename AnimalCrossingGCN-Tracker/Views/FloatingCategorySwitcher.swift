//
// FloatingCategorySwitcher.swift
//
import Foundation
import SwiftUI
import SwiftData

struct FloatingCategorySwitcher: View { //new file for the floating category switcher
    @EnvironmentObject var categoryManager: CategoryManager
    
    var body: some View { //new body section for the floating category switcher
        HStack(spacing: 16) { //new horizontal stack with spacing of 16 pixels between each category (can be adjusted)
            ForEach(Category.allCases, id: \.self) { category in //for each category in the Category enum
                Button(action: { //new button to select the category
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            categoryManager.selectedCategory = category
                        }
                    }
                }) {
                    VStack { //new vertical stack for the category
                        Image(systemName: category.symbolName) 
                            .font(.headline)
                        Text(category.rawValue)
                            .font(.caption)
                    }
                    .padding()
                    .background(categoryManager.selectedCategory == category ? Color.blue : Color.gray.opacity(0.2)) //if the category is selected, the button will be blue, otherwise it will be gray
                    .foregroundColor(categoryManager.selectedCategory == category ? .white : .primary) //if the category is selected, the text will be white, otherwise it will be the primary color
                    .cornerRadius(10) //rounding the corners of the category
                }
                .allowsHitTesting(true) //enable hit testing for buttons, should fix the layer issue
        }
    }
        .padding()
        #if os(macOS)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(Material.regular.opacity(0.8))
                .frame(maxWidth: 400) // Limit the width of the background
        }
        .allowsHitTesting(false) // Disable hit testing for the background
        #else
        .background(.regularMaterial)
        .cornerRadius(15)
        #endif
        .shadow(radius: 5)
    }
}
