//
//  ContentView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/5/24.
//

import Foundation
import SwiftUI
import SwiftData //Using SwiftData to handle user data. Testing shows it works quite well with very simple implementation! Hoping it works for the final version as well.

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Fossil.name) private var fossilsQuery: [Fossil]  // Queries to fetch fossils/bugs/fish/paintings from SwiftData
    @Query(sort: \Bug.name) private var bugsQuery: [Bug]
    @Query(sort: \Fish.name) private var fishQuery: [Fish]

    @Environment(\.horizontalSizeClass) var horizontalSizeClass  // Detect size class (compact = iPhone, regular = iPad/Mac)
    
    @State private var selectedFossil: Fossil?  // Bindable property for selected fossil
    @State private var selectedBug: Bug?
    @State private var selectedFish: Fish?

    var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                // Use NavigationStack for iPhone (using the compact width specifier)
                NavigationStack {
                    List {
                        fossilsSection
                        bugsSection
                        fishSection
                    }
                    .frame(maxHeight: .infinity)  // Ensure the List takes up all available space
                    .navigationTitle("Museum Tracker")
                }
            } else {
                // Using NavigationSplitView for macOS and iPadOS devices (regular width)
                NavigationSplitView {
                    List {
                        fossilsSection
                        bugsSection
                        fishSection
                    }
                    #if os(macOS)
                    .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                    #endif
                } detail: {
                    if let fossil = selectedFossil {
                        FossilDetailView(fossil: fossil)
                    } else if let bug = selectedBug {
                        BugDetailView(bug: bug)  // Show Bug details when a bug is selected
                    } else {
                        Text("Select an item")
                    }
                }
                .navigationTitle("Museum Tracker")
            }
        }
        .onAppear {
          //  clearAllBugs()  // Clear any old bugs for debugging, commenting out for now
            loadBugs()      // Load the updated bugs
            loadFossils()   // Load fossils
            loadFish() //Load the fish
        }
    }

    // Separate fossils section for reusability
    private var fossilsSection: some View {
        Section(header: Text("Fossils")) {
            ForEach(fossilsQuery, id: \.id) { fossil in
                Button(action: {
                    selectedFossil = fossil  // Set the selected fossil
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
            .onDelete { offsets in
                deleteFossils(offsets: offsets)  // Handle deletion of fossils
            }
        }
    }
    
    // Separate bugs section for reusability
    private var bugsSection: some View {
        Section(header: Text("Bugs")) {
            ForEach(bugsQuery, id: \.id) { bug in
                Button(action: {
                    selectedBug = bug  // Set the selected bug
                }) {
                    Toggle(isOn: Binding(
                        get: { bug.isDonated },
                        set: { newValue in
                            bug.isDonated = newValue
                        }
                    )) {
                        VStack(alignment: .leading) {
                            Text(bug.name)
                            Text("Season: \(bug.season)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .onDelete { offsets in
                deleteBugs(offsets: offsets)  // Handle deletion of bugs
            }
        }
    }
// Separate Fish section for reusability
    private var fishSection: some View {
        Section(header: Text("Fish")) {
            ForEach(fishQuery, id: \.id) { fish in //for each fish in the fishQuery (using id as the unique identifier)
                Button(action: {
                    selectedFish = fish  // Set the selected fish
                }) {
                    Toggle(isOn: Binding( //Toggle to shwo if the fish is donated or not
                        get: { fish.isDonated }, //get the boolean value of isDonated
                        set: { newValue in 
                            fish.isDonated = newValue //set the boolean value of isDonated
                        }
                    )) {
                        VStack(alignment: .leading) { //VStack to align the text to the left
                            Text(fish.name) //Display the name of the fish
                            Text("Season: \(fish.season)") //Display the season the fish is available in
                                .font(.subheadline) //Set the font size to subheadline
                                .foregroundColor(.secondary) //Set the color to secondary
                        }
                    }
                }
            }
            .onDelete { offsets in
                deleteFish(offsets: offsets)  // Handle deletion of fish
            }
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
    // Function to load predefined bugs into SwiftData if not already present
    private func loadFish() {
        if fishQuery.isEmpty {
            let fish = getDefaultFish()  // Fetch default bugs from Bug.swift
            for fish in fish {
                modelContext.insert(fish)  // Insert bugs into SwiftData context
            }
            try? modelContext.save()  // Save the new bugs to the context
        }
    }

    /* Temporary function to clear all bugs for debugging
    private func clearAllBugs() {
        for bug in bugsQuery {
            modelContext.delete(bug)
        }
        try? modelContext.save()  // Save after deleting all bugs
    }
*/
    // Function to delete fossils
    private func deleteFossils(offsets: IndexSet) {
        withAnimation {
            offsets.map { fossilsQuery[$0] }.forEach(modelContext.delete)  // Remove selected fossils
        }
    }

    // Function to delete bugs
    private func deleteBugs(offsets: IndexSet) {
        withAnimation {
            offsets.map { bugsQuery[$0] }.forEach(modelContext.delete)  // Remove selected bugs
        }
    }
    // Function to delete fish
    private func deleteFish(offsets: IndexSet) {
        withAnimation {
            offsets.map { fishQuery[$0] }.forEach(modelContext.delete)  // Remove selected fish
        }
    }
}

#Preview {
    ContentView()
}
