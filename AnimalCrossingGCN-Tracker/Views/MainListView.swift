//
// MainListView.swift
//
import Foundation
import SwiftUI
import SwiftData

struct MainListView: View { //MainListView is now a struct instead of a class, and has its own file. Conforms to the View protocol.
    @EnvironmentObject var categoryManager: CategoryManager
    @Binding var searchText: String
    @Binding var isGlobalSearch: Bool
    
    // Add these as properties
    var fossilsQuery: [Fossil]
    var bugsQuery: [Bug]
    var fishQuery: [Fish]
    var artQuery: [Art]
    
    // Computed properties for filtered results by category
    private var filteredFossils: [Fossil] {
        if searchText.isEmpty { return fossilsQuery }
        return fossilsQuery.filter { $0.name.lowercased().contains(searchText.lowercased()) || 
                                   ($0.part?.lowercased().contains(searchText.lowercased()) ?? false) }
    }
    
    private var filteredBugs: [Bug] {
        if searchText.isEmpty { return bugsQuery }
        return bugsQuery.filter { $0.name.lowercased().contains(searchText.lowercased()) || 
                                ($0.season?.lowercased().contains(searchText.lowercased()) ?? false) }
    }
    
    private var filteredFish: [Fish] {
        if searchText.isEmpty { return fishQuery }
        return fishQuery.filter { $0.name.lowercased().contains(searchText.lowercased()) || 
                                $0.season.lowercased().contains(searchText.lowercased()) }
    }
    
    private var filteredArt: [Art] {
        if searchText.isEmpty { return artQuery }
        return artQuery.filter { $0.name.lowercased().contains(searchText.lowercased()) || 
                               $0.basedOn.lowercased().contains(searchText.lowercased()) }
    }
    
    // Whether search has any results
    private var hasGlobalResults: Bool {
        return !filteredFossils.isEmpty || !filteredBugs.isEmpty || 
               !filteredFish.isEmpty || !filteredArt.isEmpty
    }
    
    private var totalResultsCount: Int {
        return filteredFossils.count + filteredBugs.count + filteredFish.count + filteredArt.count
    }
    
    var body: some View {
        Group {
            if isGlobalSearch && !searchText.isEmpty {
                // Global search results list
                List {
                    // Results counter
                    if !searchText.isEmpty {
                        if hasGlobalResults {
                            Text("Found \(totalResultsCount) items")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            Text("No results found")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Category sections
                    if !filteredFossils.isEmpty {
                        Section(header: Text("Fossils (\(filteredFossils.count))")) {
                            ForEach(filteredFossils) { fossil in
                                NavigationLink(value: fossil) {
                                    CollectibleRow(item: fossil, category: .fossils)
                                }
                            }
                        }
                    }
                    
                    if !filteredBugs.isEmpty {
                        Section(header: Text("Bugs (\(filteredBugs.count))")) {
                            ForEach(filteredBugs) { bug in
                                NavigationLink(value: bug) {
                                    CollectibleRow(item: bug, category: .bugs)
                                }
                            }
                        }
                    }
                    
                    if !filteredFish.isEmpty {
                        Section(header: Text("Fish (\(filteredFish.count))")) {
                            ForEach(filteredFish) { fish in
                                NavigationLink(value: fish) {
                                    CollectibleRow(item: fish, category: .fish)
                                }
                            }
                        }
                    }
                    
                    if !filteredArt.isEmpty {
                        Section(header: Text("Art (\(filteredArt.count))")) {
                            ForEach(filteredArt) { art in
                                NavigationLink(value: art) {
                                    CollectibleRow(item: art, category: .art)
                                }
                            }
                        }
                    }
                }
                #if os(iOS)
                .listStyle(.insetGrouped)
                #else
                .listStyle(.inset)
                #endif
            } else {
                // Regular category view
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
                }
                #if os(iOS)
                .listStyle(.insetGrouped)
                #else
                .listStyle(.inset)
                #endif
            }
        }
    }
}
