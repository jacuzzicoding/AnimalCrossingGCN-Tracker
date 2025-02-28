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
    @Binding var isGlobalSearch: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    
                TextField("Search...", text: $text)
                    .foregroundColor(.primary)
                    .disableAutocorrection(false)
                
                if !text.isEmpty { 
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // Enhanced global search toggle button with platform-specific styling
            #if os(iOS)
            Button(action: {
                isGlobalSearch.toggle()
            }) {
                HStack {
                    Image(systemName: isGlobalSearch ? "rectangle.and.text.magnifyingglass.rtl" : "rectangle.and.text.magnifyingglass")
                    Text(isGlobalSearch ? "Current" : "All")
                        .font(.caption)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(isGlobalSearch ? Color.acLeafGreen.opacity(0.2) : Color.acBlathersPurple.opacity(0.2))
                .cornerRadius(8)
            }
            .help(isGlobalSearch ? "Search current category only" : "Search across all categories")
            #else
            Button(action: {
                isGlobalSearch.toggle()
            }) {
                HStack {
                    Image(systemName: isGlobalSearch ? "rectangle.and.text.magnifyingglass.rtl" : "rectangle.and.text.magnifyingglass")
                    Text(isGlobalSearch ? "Current Category" : "All Categories")
                        .font(.caption)
                }
            }
            .buttonStyle(LinkButtonStyle())
            .help(isGlobalSearch ? "Search only in the current category" : "Search across all categories")
            #endif
        }
        .padding(.horizontal)
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
    
    // Sheets
    @State private var showingFullAnalytics = false
    @State private var showingGlobalSearch = false

    // Category manager
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @StateObject private var categoryManager = CategoryManager()
    @State private var searchText = ""
    @State private var isGlobalSearch = false

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
                ScrollView {
                VStack(spacing: 20) {
                Text("Analytics Dashboard")
                    .font(.headline)
                    .padding(.top)
                        
                    // Create a simplified preview of the analytics dashboard
                if let completionData = dataManager.getCategoryCompletionData() {
                // Museum progress card
                VStack(alignment: .leading) {
                HStack {
                Image(systemName: "museum.fill")
                        .foregroundColor(Color(red: 107/255, green: 211/255, blue: 139/255)) // .acLeafGreen
                    Text("Museum Progress")
                    .font(.headline)
                }
                
                HStack {
                Text("\(completionData.totalDonated) of \(completionData.totalCount) items donated")
                    Spacer()
                    Text("\(Int(completionData.totalProgress * 100))%")
                        .bold()
                }
                
                ProgressView(value: completionData.totalProgress)
                .tint(Color(red: 107/255, green: 211/255, blue: 139/255))
                }
                .padding()
                #if os(iOS)
                .background(Color(uiColor: UIColor.secondarySystemBackground))
                #else
                .background(Color.secondary.opacity(0.2))
                #endif
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Category progress
                VStack(alignment: .leading) {
                HStack {
                Image(systemName: "square.grid.2x2.fill")
                .foregroundColor(Color(red: 161/255, green: 122/255, blue: 196/255)) // .acBlathersPurple
                Text("Categories")
                    .font(.headline)
                }
                .padding(.bottom, 2)
                
                // Fossils
                HStack {
                        Image(systemName: "leaf.arrow.circlepath")
                            .foregroundColor(Color(red: 184/255, green: 125/255, blue: 75/255)) // .acMuseumBrown
                            Text("Fossils")
                        Spacer()
                        Text("\(completionData.fossilDonated)/\(completionData.fossilCount)")
                            .font(.subheadline)
                        Text("\(Int(completionData.fossilProgress * 100))%")
                            .bold()
                    }
                    ProgressView(value: completionData.fossilProgress)
                        .tint(Color(red: 184/255, green: 125/255, blue: 75/255))
                
                // Bugs
                HStack {
                        Image(systemName: "ant.fill")
                            .foregroundColor(.green)
                        Text("Bugs")
                    Spacer()
                        Text("\(completionData.bugDonated)/\(completionData.bugCount)")
                        .font(.subheadline)
                        Text("\(Int(completionData.bugProgress * 100))%")
                            .bold()
                    }
                    ProgressView(value: completionData.bugProgress)
                        .tint(.green)
                        
                        // Fish
                            HStack {
                            Image(systemName: "fish.fill")
                            .foregroundColor(Color(red: 122/255, green: 205/255, blue: 244/255)) // .acOceanBlue
                                Text("Fish")
                                    Spacer()
                                        Text("\(completionData.fishDonated)/\(completionData.fishCount)")
                                            .font(.subheadline)
                                        Text("\(Int(completionData.fishProgress * 100))%")
                                            .bold()
                                    }
                                    ProgressView(value: completionData.fishProgress)
                                        .tint(Color(red: 122/255, green: 205/255, blue: 244/255))
                                    
                                    // Art
                                    HStack {
                                        Image(systemName: "paintpalette.fill")
                                            .foregroundColor(Color(red: 161/255, green: 122/255, blue: 196/255)) // .acBlathersPurple
                                        Text("Art")
                                        Spacer()
                                        Text("\(completionData.artDonated)/\(completionData.artCount)")
                                            .font(.subheadline)
                                        Text("\(Int(completionData.artProgress * 100))%")
                                            .bold()
                                    }
                                    ProgressView(value: completionData.artProgress)
                                        .tint(Color(red: 161/255, green: 122/255, blue: 196/255))
                                }
                                .padding()
                                #if os(iOS)
                                .background(Color(uiColor: UIColor.secondarySystemBackground))
                                #else
                                .background(Color.secondary.opacity(0.2))
                                #endif
                                .cornerRadius(10)
                                .padding(.horizontal)
                                
                                // Timeline preview
                                let timelineData = dataManager.getDonationActivityByMonth()
                                if !timelineData.isEmpty {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Image(systemName: "clock.arrow.circlepath")
                                                .foregroundColor(Color(red: 250/255, green: 216/255, blue: 123/255)) // .acBellYellow
                                            Text("Recent Activity")
                                                .font(.headline)
                                        }
                                        .padding(.bottom, 2)
                                        
                                        ForEach(Array(timelineData.suffix(3))) { activity in
                                            HStack {
                                                Text(activity.formattedMonth)
                                                Spacer()
                                                Text("\(activity.totalCount) items")
                                                    .bold()
                                            }
                                            .padding(.vertical, 2)
                                        }
                                    }
                                    .padding()
                                    #if os(iOS)
                                    .background(Color(uiColor: UIColor.secondarySystemBackground))
                                    #else
                                    .background(Color.secondary.opacity(0.2))
                                    #endif
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                }
                                
                                // Button to show full analytics
                                Button(action: {
                                    showingFullAnalytics = true
                                }) {
                                    HStack {
                                        Image(systemName: "chart.bar.xaxis")
                                        Text("View Full Analytics")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                                .padding(.horizontal)
                                .padding(.top, 5)
                            } else {
                                VStack(spacing: 20) {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .font(.system(size: 40))
                                        .foregroundColor(.secondary)
                                    
                                    Text("No analytics data available")
                                        .foregroundColor(.secondary)
                                    
                                    Text("Add donations to see detailed analytics")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        
                                    // Generate test data button in debug mode
                                    #if DEBUG
                                    Button(action: {
                                        dataManager.generateTestDonationData()
                                    }) {
                                        Text("Generate Test Data")
                                            .padding()
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    #endif
                                }
                                .frame(maxWidth: .infinity, minHeight: 300)
                                .padding()
                            }
                        }
                        .padding(.bottom, 120) // Add extra bottom padding to prevent overlap with FloatingCategorySwitcher
                    }
                } else {
                    // Existing search and main list content
                    SearchBar(text: $searchText, isGlobalSearch: $isGlobalSearch)
                    
                    MainListView(
                        searchText: $searchText,
                        isGlobalSearch: $isGlobalSearch,
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
                .padding(.horizontal, 10) // Add horizontal padding to prevent edge overlap
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
                        .toolbar {
                            #if os(iOS)
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    showingGlobalSearch = true
                                }) {
                                    Image(systemName: "magnifyingglass")
                                }
                            }
                            #else
                            ToolbarItem {
                                Button(action: {
                                    showingGlobalSearch = true
                                }) {
                                    Image(systemName: "magnifyingglass")
                                }
                            }
                            #endif
                        }
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
                .toolbar {
                    #if os(iOS)
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            showingGlobalSearch = true
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                    #else
                    ToolbarItem {
                        Button(action: {
                            showingGlobalSearch = true
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                    #endif
                }
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
                AnalyticsDashboardView()
                    .navigationTitle("Analytics Dashboard")
                    .toolbar {
                        #if os(iOS)
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                showingFullAnalytics = false
                            }
                        }
                        #else
                        ToolbarItem {
                            Button("Done") {
                                showingFullAnalytics = false
                            }
                        }
                        #endif
                    }
            }
            .environmentObject(dataManager)
        }
        .sheet(isPresented: $showingGlobalSearch, onDismiss: {
            // Reset the toggle when the global search sheet is dismissed
            isGlobalSearch = false
        }) {
            // Show global search in a sheet
            GlobalSearchView()
                .environmentObject(dataManager)
                .environmentObject(categoryManager)
        }
    }
}
