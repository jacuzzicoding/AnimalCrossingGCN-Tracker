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
        if let fossils = museumItems["Fossils"] {
            ForEach(fossils.indices, id: \.self) { index in
                let fossil = fossils[index]
                Toggle(isOn: Binding(
                    get: { fossil.isDonated },
                    set: { newValue in
                        museumItems["Fossils"]?[index].isDonated = newValue
                    }
                )) {
                    Text("\(fossil.name) - \(fossil.part ?? "")")
                }
            }
            .onDelete { offsets in
                deleteItems(category: "Fossils", offsets: offsets)
            }
        }
    }
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
            Fossil(name: "T. Rex", part: "Skull", isDonated: false),
            Fossil(name: "T. Rex", part: "Torso", isDonated: false),
            Fossil(name: "T. Rex", part: "Tail", isDonated: false),
            Fossil(name: "Triceratops", part: "Skull", isDonated: false),
            Fossil(name: "Triceratops", part: "Torso", isDonated: false),
            Fossil(name: "Triceratops", part: "Tail", isDonated: false),
            Fossil(name: "Stegosaurus", part: "Skull", isDonated: false),
            Fossil(name: "Stegosaurus", part: "Torso", isDonated: false),
            Fossil(name: "Stegosaurus", part: "Tail", isDonated: false),
            Fossil(name: "Pteranodon", part: "Skull", isDonated: false),
            Fossil(name: "Pteranodon", part: "Left Wing", isDonated: false),
            Fossil(name: "Pteranodon", part: "Right Wing", isDonated: false),
            Fossil(name: "Plesiosaurus", part: "Skull", isDonated: false),
            Fossil(name: "Plesiosaurus", part: "Neck", isDonated: false),
            Fossil(name: "Plesiosaurus", part: "Torso", isDonated: false),
            Fossil(name: "Apatosaurus", part: "Skull", isDonated: false),
            Fossil(name: "Apatosaurus", part: "Torso", isDonated: false),
            Fossil(name: "Apatosaurus", part: "Tail", isDonated: false),
            Fossil(name: "Mammoth", part: "Skull", isDonated: false),
            Fossil(name: "Mammoth", part: "Torso", isDonated: false),
            Fossil(name: "Amber", isDonated: false),
            Fossil(name: "Ammonite", isDonated: false),
            Fossil(name: "Dinosaur Egg", isDonated: false),
            Fossil(name: "Dinosaur Track", isDonated: false),
            Fossil(name: "Trilobite", isDonated: false)
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
