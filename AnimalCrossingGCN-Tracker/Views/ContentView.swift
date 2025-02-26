//
//  ContentView.swift
// 

import Foundation
import SwiftUI
import SwiftData
import Charts

// Protocol conformance is now handled directly in each model file

class CategoryManager: ObservableObject {
    @Published var selectedCategory: Category = .fossils
    @Published var selectedItem: (any CollectibleItem)? = nil
    @Published var showingAnalytics: Bool = false
    
    func switchCategory(_ newCategory: Category) {
        if selectedCategory != newCategory {
            selectedItem = nil  // Clear selection when switching categories
            selectedCategory = newCategory
            showingAnalytics = false
        }
    }
    
    func showAnalytics() {
        selectedItem = nil  // Clear selection
        showingAnalytics = true
    }
}

// Enhanced Category enum with symbols built into swift
enum Category: String, CaseIterable {
    case fossils = "Fossils"
    case bugs = "Bugs"
    case fish = "Fish"
    case art = "Art"
    
    // New variable to get the symbol name for each category
    var symbolName: String {
        switch self {
        case .fossils: return "leaf.arrow.circlepath"  //might find a better symbol
        case .bugs: return "ant.fill"
        case .fish: return "fish.fill"
        case .art: return "paintpalette.fill"
        }
    }
    
    func getDefaultData() -> [any CollectibleItem] { //function to get the default data for each category using the new CollectibleItem protocol
        switch self {
        case .fossils: return getDefaultFossils()
        case .bugs: return getDefaultBugs()
        case .fish: return getDefaultFish()
        case .art: return getDefaultArt()
        }
    }
    
    @ViewBuilder //new view builder to return the correct detail view based on the category selected
    func detailView<T: CollectibleItem>(for item: T) -> some View {
        switch self {
        case .fossils:
            if let fossil = item as? Fossil {
                FossilDetailView(fossil: fossil)
            }
        case .bugs:
            if let bug = item as? Bug {
                BugDetailView(bug: bug)
            }
        case .fish:
            if let fish = item as? Fish {
                FishDetailView(fish: fish)
            }
        case .art:
            if let art = item as? Art {
                ArtDetailView(art: art)
            }
        }
    }
}

// Custom SearchBar view for improved UI
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass") //new magnifying glass icon
                    .foregroundColor(.gray)
                TextField("Search...", text: $text)
                    .foregroundColor(.primary)
                    .disableAutocorrection(false) //now allows autocorrection
                if !text.isEmpty { 
                    Button(action: { //new button to clear the text
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill") //if text is not empty, show the xmark to clear the text
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
}

// Enhanced CollectibleRow for better visual presentation
struct CollectibleRow<T: CollectibleItem>: View {
    let item: T //new item variable
    let category: Category
    
    var body: some View {
        HStack {
            // Category icon with colored background
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: category.symbolName)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                // Category-specific details (keeping existing logic)
                if let fossil = item as? Fossil, let part = fossil.part { //so, if the item is a fossil and the part is not nil
                    Text(part) //then display the part
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else if let bug = item as? Bug, let season = bug.season {
                    Text("Season: \(season)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else if let fish = item as? Fish {
                    Text("Season: \(fish.season)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else if let art = item as? Art {
                    Text("Based on: \(art.basedOn)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Enhanced donation indicator
            Image(systemName: item.isDonated ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.isDonated ? .green : .gray)
                .font(.title3)
        }
        .padding(.vertical, 8)
    }
}

// Updated CategorySection with enhanced row presentation
struct CategorySection<T: CollectibleItem>: View { //this is the new CategorySection struct
    @EnvironmentObject var categoryManager: CategoryManager
    let category: Category //new category variable
    let items: [T] //an array of items
    @Binding var searchText: String //binding to the search text
    
    var filteredItems: [T] { //new filteredItems variable
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.lowercased().contains(searchText.lowercased()) } //filter the items based on the search text, ignoring case
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

//helper struct
struct LazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}

struct ContentView: View { // Updated ContentView
    // Existing environment and query properties
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Fossil.name) private var fossilsQuery: [Fossil]
    @Query(sort: \Bug.name) private var bugsQuery: [Bug]
    @Query(sort: \Fish.name) private var fishQuery: [Fish]
    @Query(sort: \Art.name) private var artQuery: [Art]

    // Town managing
    @EnvironmentObject var dataManager: DataManager
    @State private var isEditingTown = false
    @State private var newTownName: String = ""
    
    // Analytics sheet
    @State private var showingFullAnalytics = false

    // Category manager
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @StateObject private var categoryManager = CategoryManager()
    @State private var searchText = ""

    private var mainContent: some View {
        ZStack(alignment: .bottom) { //align the floating category switcher to the bottom
            VStack(spacing: 0) {
                // Town Section
                HStack {
                    Text("Town Name:")
                        .font(.headline)
                    Spacer()
                    Text(dataManager.currentTown?.name ?? "Loading...")
                        .font(.title2)
                    Button(action: {
                        // Initialize with current town name or empty if not set
                        newTownName = dataManager.currentTown?.name ?? ""
                        isEditingTown = true
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding()

                Divider()

                // Display either the main list or analytics view based on the CategoryManager state
                if categoryManager.showingAnalytics {
                    VStack {
                        Text("Analytics Dashboard")
                            .font(.headline)
                            .padding(.bottom)
                            
                        // Create a simple analytics view directly within ContentView for now
                        if let town = dataManager.currentTownDTO {
                            VStack(spacing: 16) {
                                // Progress overview
                                VStack(alignment: .leading) {
                                    Text("Museum Progress")
                                        .font(.title3)
                                    
                                    HStack {
                                        Text("Overall: \(Int(town.totalProgress * 100))%")
                                        Spacer()
                                    }
                                    ProgressView(value: town.totalProgress)
                                        .tint(.purple)
                                    
                                    Divider()
                                    
                                    // Category progress
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Fossils: \(Int(town.fossilProgress * 100))%")
                                            ProgressView(value: town.fossilProgress)
                                                .tint(.brown)
                                        }
                                        VStack(alignment: .leading) {
                                            Text("Bugs: \(Int(town.bugProgress * 100))%")
                                            ProgressView(value: town.bugProgress)
                                                .tint(.green)
                                        }
                                    }
                                    
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Fish: \(Int(town.fishProgress * 100))%")
                                            ProgressView(value: town.fishProgress)
                                                .tint(.blue)
                                        }
                                        VStack(alignment: .leading) {
                                            Text("Art: \(Int(town.artProgress * 100))%")
                                            ProgressView(value: town.artProgress)
                                                .tint(.purple)
                                        }
                                    }
                                }
                                .padding()
                                #if os(iOS)
                                .background(Color(uiColor: UIColor.systemGray6))
                                #else
                                .background(Color.secondary.opacity(0.1))
                                #endif
                                
                                // Note about accessing full analytics
                                Text("Tap 'Full Analytics' below to access detailed charts and visualizations")
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                // Button to show full analytics
                                Button(action: {
                                    showingFullAnalytics = true
                                }) {
                                    Text("Full Analytics")
                                }
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .padding()
                        } else {
                            Text("Select a town to view analytics")
                                .foregroundColor(.secondary)
                        }
                    }
                } else {
                    // Existing search and main list content
                    SearchBar(text: $searchText)
                    MainListView(
                        searchText: $searchText,
                        fossilsQuery: fossilsQuery,
                        bugsQuery: bugsQuery,
                        fishQuery: fishQuery,
                        artQuery: artQuery
                    )
                }
            }

            // Floating category switcher overlay
            FloatingCategorySwitcher()
                .padding(.bottom, 20)
        }
    }
    /*Data Loading Section*/ //moving to DataManager.swift soon
    // Keeping the existing loadData function unchanged
    private func loadData() {
        for category in Category.allCases {
            let data = category.getDefaultData()
            switch category {
            case .fossils:
                if fossilsQuery.isEmpty {
                    data.compactMap { $0 as? Fossil }.forEach { modelContext.insert($0) }
                }
            case .bugs:
                if bugsQuery.isEmpty {
                    data.compactMap { $0 as? Bug }.forEach { modelContext.insert($0) }
                }
            case .fish:
                if fishQuery.isEmpty {
                    data.compactMap { $0 as? Fish }.forEach { modelContext.insert($0) }
                }
            case .art:
                if artQuery.isEmpty {
                    data.compactMap { $0 as? Art }.forEach { modelContext.insert($0) }
                }
            }
        }
        try? modelContext.save()
    }

    @ViewBuilder
    func addNavigationDestinations<Content: View>(_ content: Content) -> some View {
        content
            .navigationDestination(for: Fossil.self) { fossil in
                FossilDetailView(fossil: fossil)
            }
            .navigationDestination(for: Bug.self) { bug in
                BugDetailView(bug: bug)
            }
            .navigationDestination(for: Fish.self) { fish in
                FishDetailView(fish: fish)
            }
            .navigationDestination(for: Art.self) { art in
                ArtDetailView(art: art)
            }
    }

    var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                // iPhone section
                NavigationStack {
                    addNavigationDestinations(mainContent)
                        .navigationTitle("Museum Tracker")
                }
            } else {
                // iPad/Mac section
                NavigationSplitView {
                    addNavigationDestinations(mainContent)
#if os(macOS)
                        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
                } detail: {
#if os(macOS)
                    Text("Select an item")
                        .frame(minWidth: 300)
#else
                    Text("Select an item")
#endif
                }
                .navigationTitle("Museum Tracker")
            }
        }
        .environmentObject(categoryManager)
        .onAppear {
            loadData()
        }
        .sheet(isPresented: $isEditingTown) {
            EditTownView(isPresented: $isEditingTown, townName: $newTownName)
                .environmentObject(dataManager)
        }
        .sheet(isPresented: $showingFullAnalytics) {
            // Show full analytics dashboard in a sheet
            NavigationView {
                VStack {
                    Text("Analytics Dashboard")
                        .font(.largeTitle)
                        .padding(.bottom)
                        
                    if let town = dataManager.currentTownDTO {
                        // Show progress information
                        Text("Town: \(town.name)")
                            .font(.headline)
                        Text("Overall Progress: \(Int(town.totalProgress * 100))%")
                            .padding(.bottom)
                            
                        // Display message about the implementation
                        Text("The full analytics implementation is being integrated.")
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Text("In the complete implementation, this screen will show donation timelines, category breakdowns, and seasonal availability charts.")
                            .multilineTextAlignment(.center)
                            .font(.caption)
                            .padding()
                    } else {
                        Text("Please select a town to view analytics")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        // Keep your existing toolbar content here
                    }
                }
            }
            .environmentObject(dataManager)
        }
    }
}
