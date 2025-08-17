//
//  CategoryManager.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Claude 4 on 5/24/25.
//

import Foundation
import SwiftUI

// MARK: - Category Enum

/// Represents the different collection categories in Animal Crossing
enum Category: String, CaseIterable {
    case fossils = "Fossils"
    case bugs = "Bugs" 
    case fish = "Fish"
    case art = "Art"
    
    /// System symbol name for each category
    var symbolName: String {
        switch self {
        case .fossils: return "leaf.arrow.circlepath"
        case .bugs: return "ant.fill"
        case .fish: return "fish.fill"
        case .art: return "paintpalette.fill"
        }
    }
}

// MARK: - CategoryManager

/// Manages category selection and navigation state for the app
class CategoryManager: ObservableObject {
    @Published var selectedCategory: Category = .fossils
    @Published var selectedItem: (any CollectibleItem)? = nil
    @Published var showingAnalytics: Bool = false
    
    /// Switches to a new category and clears current selection
    func switchCategory(_ newCategory: Category) {
        if selectedCategory != newCategory {
            selectedItem = nil  // Clear selection when switching categories
            selectedCategory = newCategory
            showingAnalytics = false
        }
    }
    
    /// Shows the analytics view and clears current selection
    func showAnalytics() {
        selectedItem = nil  // Clear selection
        showingAnalytics = true
    }
}
