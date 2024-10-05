//
//  ContentView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/5/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    // Dictionary to hold arrays of items for each category
    @State private var museumItems: [String: [Fossil]] = [
        "Fossils": [], // You'll populate this with the predefined fossils
        "Bugs": [],
        "Fish": [],
        "Art": []
    ]

    var body: some View {
        NavigationSplitView {
            List {
                // Fossils Section
                Section(header: Text("Fossils")) {
                    ForEach(museumItems["Fossils"] ?? [], id: \.id) { fossil in
                        NavigationLink {
                            Text("\(fossil.name) - \(fossil.part ?? "")")
                        } label: {
                            Text("\(fossil.name) - \(fossil.part ?? "")")
                        }
                    }
                    .onDelete { offsets in
                        deleteItems(category: "Fossils", offsets: offsets)
                    }
                }
                // Other sections (Bugs, Fish, Art) can be added later
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addFossil) {
                        Label("Add Fossil", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .onAppear {
            loadFossils() // Load fossils when the view appears
        }
    }

    // Function to load predefined fossils
    private func loadFossils() {
        let fossils = [
            Fossil(name: "T. Rex", part: "Skull", isDonated: <#Bool#>),
            Fossil(name: "T. Rex", part: "Torso" isDonated: <#Bool#>),
            Fossil(name: "T. Rex", part: "Tail", isDonated: <#Bool#>),
            Fossil(name: "Triceratops", part: "Skull", isDonated: <#Bool#>),
            Fossil(name: "Triceratops", part: "Torso", isDonated: <#Bool#>),
            Fossil(name: "Triceratops", part: "Tail", isDonated: <#Bool#>),
            Fossil(name: "Stegosaurus", part: "Skull", isDonated: <#Bool#>),
            Fossil(name: "Stegosaurus", part: "Torso", isDonated: <#Bool#>),
            Fossil(name: "Stegosaurus", part: "Tail", isDonated: <#Bool#>),
            Fossil(name: "Pteranodon", part: "Skull", isDonated: <#Bool#>),
            Fossil(name: "Pteranodon", part: "Left Wing", isDonated: <#Bool#>),
            Fossil(name: "Pteranodon", part: "Right Wing", isDonated: <#Bool#>),
            Fossil(name: "Plesiosaurus", part: "Skull", isDonated: <#Bool#>),
            Fossil(name: "Plesiosaurus", part: "Neck", isDonated: <#Bool#>),
            Fossil(name: "Plesiosaurus", part: "Torso", isDonated: <#Bool#>),
            Fossil(name: "Apatosaurus", part: "Skull", isDonated: <#Bool#>),
            Fossil(name: "Apatosaurus", part: "Torso", isDonated: <#Bool#>),
            Fossil(name: "Apatosaurus", part: "Tail", isDonated: <#Bool#>),
            Fossil(name: "Mammoth", part: "Skull", isDonated: <#Bool#>),
            Fossil(name: "Mammoth", part: "Torso", isDonated: <#Bool#>),
            Fossil(name: "Amber", isDonated: <#Bool#>),
            Fossil(name: "Ammonite", isDonated: <#Bool#>),
            Fossil(name: "Dinosaur Egg", isDonated: <#Bool#>),
            Fossil(name: "Dinosaur Track", isDonated: <#Bool#>),
            Fossil(name: "Trilobite", isDonated: <#Bool#>)
        ]
        
        museumItems["Fossils"] = fossils
    }

    // Function to add a fossil manually
    private func addFossil() {
        withAnimation {
            let newFossil = Fossil(name: "New Fossil", part: "Part", isDonated: false)
            museumItems["Fossils"]?.append(newFossil)
        }
    }

    // Function to delete items from a specific category
    private func deleteItems(category: String, offsets: IndexSet) {
        withAnimation {
            museumItems[category]?.remove(atOffsets: offsets)
        }
    }
}

#Preview {
    ContentView()
}
