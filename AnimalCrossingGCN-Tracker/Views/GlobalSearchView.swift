//
//  GlobalSearchView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 2/28/25.
//

import SwiftUI
import SwiftData

// Import UIKit conditionally for platform-specific code
#if canImport(UIKit)
import UIKit
#endif

/// View for searching across all collectible categories
struct GlobalSearchView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var categoryManager: CategoryManager
    @State private var searchText: String = ""
    @State private var searchResults: GlobalSearchResults?
    @State private var isSearching: Bool = false
    @State private var showingHistory: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                // Search bar with history toggle
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search across all categories...", text: $searchText)
                            .onChange(of: searchText) { _, newValue in
                                if newValue.isEmpty {
                                    searchResults = nil
                                    isSearching = false
                                } else {
                                    isSearching = true
                                    performSearch()
                                }
                            }
                            .submitLabel(.search)
                            .onSubmit {
                                performSearch()
                            }
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                searchResults = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button(action: {
                        showingHistory.toggle()
                    }) {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                    }
                    .popover(isPresented: $showingHistory) {
                        SearchHistoryView { historyItem in
                            searchText = historyItem
                            showingHistory = false
                            performSearch()
                        }
                        .environmentObject(dataManager)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                // Results or placeholder
                if let results = searchResults {
                    if results.isEmpty {
                        // No results view
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("No results found")
                                .font(.headline)
                            Text("Try different keywords or check spelling")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    } else {
                        // Results list
                        List {
                            // Results counters
                            HStack {
                                Text("Found \(results.totalCount) items")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .listRowBackground(Color.clear)
                            
                            // Fossils section
                            if !results.fossils.isEmpty {
                                Section(header: Text("Fossils (\(results.fossils.count))")) {
                                    ForEach(results.fossils) { fossil in
                                        NavigationLink {
                                            FossilDetailView(fossil: fossil)
                                        } label: {
                                            CollectibleRow(item: fossil, category: .fossils)
                                                .onTapGesture {
                                                    categoryManager.selectedCategory = .fossils
                                                    categoryManager.selectedItem = fossil
                                                    dismiss()
                                                }
                                        }
                                    }
                                }
                            }
                            
                            // Bugs section
                            if !results.bugs.isEmpty {
                                Section(header: Text("Bugs (\(results.bugs.count))")) {
                                    ForEach(results.bugs) { bug in
                                        NavigationLink {
                                            BugDetailView(bug: bug)
                                        } label: {
                                            CollectibleRow(item: bug, category: .bugs)
                                                .onTapGesture {
                                                    categoryManager.selectedCategory = .bugs
                                                    categoryManager.selectedItem = bug
                                                    dismiss()
                                                }
                                        }
                                    }
                                }
                            }
                            
                            // Fish section
                            if !results.fish.isEmpty {
                                Section(header: Text("Fish (\(results.fish.count))")) {
                                    ForEach(results.fish) { fish in
                                        NavigationLink {
                                            FishDetailView(fish: fish)
                                        } label: {
                                            CollectibleRow(item: fish, category: .fish)
                                                .onTapGesture {
                                                    categoryManager.selectedCategory = .fish
                                                    categoryManager.selectedItem = fish
                                                    dismiss()
                                                }
                                        }
                                    }
                                }
                            }
                            
                            // Art section
                            if !results.art.isEmpty {
                                Section(header: Text("Art (\(results.art.count))")) {
                                    ForEach(results.art) { art in
                                        NavigationLink {
                                            ArtDetailView(art: art)
                                        } label: {
                                            CollectibleRow(item: art, category: .art)
                                                .onTapGesture {
                                                    categoryManager.selectedCategory = .art
                                                    categoryManager.selectedItem = art
                                                    dismiss()
                                                }
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
                    }
                } else if isSearching {
                    // Loading indicator
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                } else {
                    // Search prompt
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "text.magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundColor(.blue.opacity(0.7))
                        
                        Text("Search Across All Categories")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            SearchFeatureItem(icon: "leaf.arrow.circlepath", text: "Fossils", color: .acMuseumBrown)
                            SearchFeatureItem(icon: "ant.fill", text: "Bugs", color: .green)
                            SearchFeatureItem(icon: "fish.fill", text: "Fish", color: .acOceanBlue)
                            SearchFeatureItem(icon: "paintpalette.fill", text: "Art", color: .acBlathersPurple)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding()
                    Spacer()
                }
            }
            .navigationTitle("Global Search")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func performSearch() {
        guard !searchText.isEmpty else {
            searchResults = nil
            return
        }
        
        // Slight delay to avoid too many searches while typing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let townId = dataManager.currentTown?.id {
                searchResults = dataManager.searchAllCategories(query: searchText, townId: townId)
            } else {
                searchResults = dataManager.searchAllCategories(query: searchText)
            }
            isSearching = false
        }
    }
}

/// Helper view for search feature items
struct SearchFeatureItem: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(text)
            Spacer()
        }
    }
}

/// Search history view
struct SearchHistoryView: View {
    @EnvironmentObject var dataManager: DataManager
    var onSelect: (String) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Recent Searches")
                    .font(.headline)
                Spacer()
                Button("Clear") {
                    dataManager.clearSearchHistory()
                }
                .font(.caption)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            if dataManager.getSearchHistory().isEmpty {
                Spacer()
                Text("No recent searches")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                List {
                    ForEach(dataManager.getSearchHistory(), id: \.self) { searchItem in
                        Button(action: {
                            onSelect(searchItem)
                        }) {
                            HStack {
                                Image(systemName: "clock.arrow.circlepath")
                                    .foregroundColor(.gray)
                                Text(searchItem)
                                Spacer()
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .frame(width: 300, height: 300)
    }
}

// Preview for design and testing
struct GlobalSearchView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Town.self, Fossil.self, Bug.self, Fish.self, Art.self, configurations: config)
        
        let context = container.mainContext
        
        // Create sample data for preview
        let town = Town(name: "PreviewTown")
        context.insert(town)
        
        let dataManager = DataManager(modelContext: context)
        let categoryManager = CategoryManager()
        
        return GlobalSearchView()
            .environmentObject(dataManager)
            .environmentObject(categoryManager)
    }
}
