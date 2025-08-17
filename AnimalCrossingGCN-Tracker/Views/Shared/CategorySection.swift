//
//  CategorySection.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Claude 4 on 5/24/25.
//

import SwiftUI

/// Updated CategorySection with enhanced row presentation
struct CategorySection<T: CollectibleItem>: View {
    @EnvironmentObject var categoryManager: CategoryManager
    let category: Category
    let items: [T]
    @Binding var searchText: String
    
    var filteredItems: [T] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        ForEach(filteredItems) { item in
            NavigationLink(value: item) {
                CollectibleRow(item: item, category: category)
            }
            #if os(macOS)
            .buttonStyle(PlainButtonStyle())
            #endif
        }
        .onAppear {
            debugPrint("\(category) section showing \(filteredItems.count) items")
        }
    }
}
