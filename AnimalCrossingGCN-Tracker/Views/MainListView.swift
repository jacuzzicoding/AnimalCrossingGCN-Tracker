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
        #if os(iOS) //same styling as before for now
        .listStyle(InsetGroupedListStyle())
        #else
        .listStyle(SidebarListStyle())
        .frame(minWidth: 200)
        .allowsHitTesting(true)
        #endif
    }
}