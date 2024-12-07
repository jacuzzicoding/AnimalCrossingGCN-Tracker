//
// MainListView.swift
//
import Foundation
import SwiftUI
import SwiftData

struct MainListView: View { //MainListView is now a struct instead of a class, and has its own file. Conforms to the View protocol.
    @EnvironmentObject var categoryManager: CategoryManager
    @Binding var searchText: String
    
    // Add these as properties
    var fossilsQuery: [Fossil]
    var bugsQuery: [Bug]
    var fishQuery: [Fish]
    var artQuery: [Art]
    
    var body: some View {
        List {
            // Force list to recreate when category changes
            let _ = debugPrint("List rebuilding for category: \(categoryManager.selectedCategory)")
            
            Group {
                switch categoryManager.selectedCategory {
                case .fossils:
                    CategorySection(category: .fossils, items: fossilsQuery, searchText: $searchText)
                case .bugs:
                    CategorySection(category: .bugs, items: bugsQuery, searchText: $searchText)
                case .fish:
                    CategorySection(category: .fish, items: fishQuery, searchText: $searchText)
                case .art:
                    CategorySection(category: .art, items: artQuery, searchText: $searchText)
                }
            }
#if os(iOS)
            .listStyle(InsetGroupedListStyle())
#else
            .listStyle(SidebarListStyle())
            .frame(minWidth: 200)
            .allowsHitTesting(true)
            .zIndex(1) //Puts list above other layers.
#endif
        }
    }
}
