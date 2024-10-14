//
//  ContentView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/5/24.
//

import Foundation
import SwiftUI
import SwiftData // Using SwiftData to handle user data. Testing shows it works quite well with very simple implementation! Hoping it works for the final version as well.

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Fossil.name) private var fossilsQuery: [Fossil]  // Queries to fetch fossils/bugs/fish/paintings from SwiftData
    @Query(sort: \Bug.name) private var bugsQuery: [Bug]
    @Query(sort: \Fish.name) private var fishQuery: [Fish]
    @Query(sort: \Art.name) private var artQuery: [Art]
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass  // Detect size class (compact = iPhone, regular = iPad/Mac)
    
    @State private var selectedFossil: Fossil?  // Bindable property for selected fossil
    @State private var selectedBug: Bug?
    @State private var selectedFish: Fish?  // Keeping 'Fish' capitalization for now, as fixing it breaks it
    @State private var selectedArt: Art?
    
    @State private var searchText = ""  // State property for search text
    @State private var selectedCategories: Set<String> = ["Fossils", "Bugs", "Fish", "Art"] // State property for selected categories
    
    var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                // IPHONE SECTION, using navigationstack
                NavigationStack {
                    VStack {
                        searchBar  // Add the search bar here
                        categoryFilter  // Add the category filter here
                        List {
                            if selectedCategories.contains("Fossils") {
                                fossilsSection
                            }
                            if selectedCategories.contains("Bugs") {
                                bugsSection
                            }
                            if selectedCategories.contains("Fish") {
                                fishSection
                            }
                            if selectedCategories.contains("Art") {
                                artSection
                            }
                        }
                        .frame(maxHeight: .infinity)  // Ensure the List takes up all available space
                    }
                    .navigationTitle("Museum Tracker")
                    .background(
                        Group {
                            if let fossil = selectedFossil {
                                FossilDetailView(fossil: fossil)
                            } else if let bug = selectedBug {
                                BugDetailView(bug: bug)
                            } else if let fish = selectedFish {
                                FishDetailView(Fish: fish)
                            } else if let art = selectedArt {
                                ArtDetailView(art: art)
                            } else {
                                Text("Select an item!")
                            }
                        }
                    )
                }
            } else {
                // Using NavigationSplitView for macOS and iPadOS devices (regular width)
                NavigationSplitView {
                    VStack {
                        searchBar  // Add the search bar here
                        categoryFilter  // Add the category filter here
                        List {
                            if selectedCategories.contains("Fossils") {
                                fossilsSection
                            }
                            if selectedCategories.contains("Bugs") {
                                bugsSection
                            }
                            if selectedCategories.contains("Fish") {
                                fishSection
                            }
                            if selectedCategories.contains("Art") {
                                artSection
                            }
                        }
                    }
    #if os(macOS)
                    .navigationSplitViewColumnWidth(min: 180, ideal: 200)
    #endif
                } detail: {
                    if let fossil = selectedFossil {
                        FossilDetailView(fossil: fossil)
                    } else if let bug = selectedBug {
                        BugDetailView(bug: bug)  // Show Bug details when a bug is selected
                    } else if let fish = selectedFish {
                        FishDetailView(Fish: fish)  // Keeping 'Fish' uppercase for now
                    } else if let art = selectedArt {
                        ArtDetailView(art: art)
                    } else {
                        Text("Select an item")
                    }
                }
                .navigationTitle("Museum Tracker")
            }
        }
        .onAppear {
            loadBugs()      // Load the updated bugs
            loadFossils()   // Load fossils
            loadFish()      // Load the fish
            loadArt()       // Load the art
        }
    }
    
    // Search bar view
    private var searchBar: some View {
        HStack {
            TextField("Search...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
    
    // Category filter view
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(["Fossils", "Bugs", "Fish", "Art"], id: \.self) { category in
                    Toggle(category, isOn: Binding(
                        get: { selectedCategories.contains(category) },
                        set: { isOn in
                            if isOn {
                                selectedCategories.insert(category)
                            } else {
                                selectedCategories.remove(category)
                            }
                        }
                    ))
                    .toggleStyle(ButtonToggleStyle())
                    .padding(.horizontal, 8)
                }
            }
            .padding()
        }
    }
    
    // Separate fossils section for reusability with search filter
    private var fossilsSection: some View {
        Section(header: Text("Fossils")) {
            ForEach(filteredFossils, id: \.id) { fossil in
                Button(action: {
                    selectedFossil = fossil  // Set the selected fossil
                    selectedBug = nil        // Clear other selections
                    selectedFish = nil
                    selectedArt = nil
                }) {
                    Toggle(isOn: Binding(
                        get: { fossil.isDonated },
                        set: { newValue in
                            fossil.isDonated = newValue
                        }
                    )) {
                        VStack(alignment: .leading) {
                            Text(fossil.name)
                            if let part = fossil.part {
                                Text(part)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Separate bugs section for reusability with search filter
    private var bugsSection: some View {
        Section(header: Text("Bugs")) {
            ForEach(filteredBugs, id: \.id) { bug in
                Button(action: {
                    selectedBug = bug  // Set the selected bug
                    selectedFossil = nil  // Clear other selections
                    selectedFish = nil
                    selectedArt = nil
                }) {
                    Toggle(isOn: Binding(
                        get: { bug.isDonated },
                        set: { newValue in
                            bug.isDonated = newValue
                        }
                    )) {
                        VStack(alignment: .leading) {
                            Text(bug.name)
                            Text("Season: \(bug.season ?? "N/A")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
    }
    
    // Separate fish section for reusability with search filter
    private var fishSection: some View {
        Section(header: Text("Fish")) {
            ForEach(filteredFish, id: \.id) { fish in  // Keeping 'Fish' uppercase for now
                Button(action: {
                    selectedFish = fish  // Set the selected fish
                    selectedBug = nil    // Clear other selections
                    selectedFossil = nil
                    selectedArt = nil
                }) {
                    Toggle(isOn: Binding(
                        get: { fish.isDonated },
                        set: { newValue in
                            fish.isDonated = newValue
                        }
                    )) {
                        VStack(alignment: .leading) {
                            Text(fish.name)
                            Text("Season: \(fish.season)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
    }
    
    // Separate art section for reusability with search filter
    private var artSection: some View {
        Section(header: Text("Art")) {
            ForEach(filteredArt, id: \.id) { art in
                Button(action: {
                    selectedArt = art  // Set the selected art
                    selectedBug = nil  // Clear other selections
                    selectedFossil = nil
                    selectedFish = nil
                }) {
                    Toggle(isOn: Binding(
                        get: { art.isDonated },
                        set: { newValue in
                            art.isDonated = newValue
                        }
                    )) {
                        VStack(alignment: .leading) {
                            Text(art.name)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
    }
    
    // Filtered fossils based on search text and selected categories
    private var filteredFossils: [Fossil] {
        if searchText.isEmpty {
            return fossilsQuery
        } else {
            return fossilsQuery.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    // Filtered bugs based on search text and selected categories
    private var filteredBugs: [Bug] {
        if searchText.isEmpty {
            return bugsQuery
        } else {
            return bugsQuery.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    // Filtered fish based on search text and selected categories
    private var filteredFish: [Fish] {
        if searchText.isEmpty {
            return fishQuery
        } else {
            return fishQuery.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    // Filtered art based on search text and selected categories
    private var filteredArt: [Art] {
        if searchText.isEmpty {
            return artQuery
        } else {
            return artQuery.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    // Function to load predefined fossils into SwiftData if not already present
    private func loadFossils() {
        if fossilsQuery.isEmpty {
            let fossils = getDefaultFossils()  // Fetch default fossils from Fossils.swift
            for fossil in fossils {
                modelContext.insert(fossil)  // Insert fossils into SwiftData context
            }
            try? modelContext.save()  // Save the fossils
        }
    }
    
    // Function to load predefined bugs into SwiftData if not already present
    private func loadBugs() {
        if bugsQuery.isEmpty {
            let bugs = getDefaultBugs()  // Fetch default bugs from Bug.swift
            for bug in bugs {
                modelContext.insert(bug)  // Insert bugs into SwiftData context
            }
            try? modelContext.save()  // Save the new bugs to the context
        }
    }
    
    // Function to load predefined fish into SwiftData if not already present
    private func loadFish() {
        if fishQuery.isEmpty {
            let fish = getDefaultFish()  // Fetch default fish from Fish.swift
            for fish in fish {
                modelContext.insert(fish)  // Insert fish into SwiftData context
            }
            try? modelContext.save()  // Save the new fish to the context
        }
    }
    
    // Function to load predefined art into SwiftData if not already present
    private func loadArt() {
        if artQuery.isEmpty {
            let art = getDefaultArt()  // Fetch default art from Art.swift
            for art in art {
                modelContext.insert(art)  // Insert art into SwiftData context
            }
            try? modelContext.save()  // Save the new art to the context
        }
    }
}

// Custom toggle style for the category filter buttons
struct ButtonToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            configuration.label
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(configuration.isOn ? Color.blue : Color.gray.opacity(0.2))
                )
        }
        .foregroundColor(configuration.isOn ? .white : .primary)
    }
}
