//
//  Fossil.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/5/24.
//
import Foundation
import SwiftData
import SwiftUI

// This function returns the default array of fossils
func getDefaultFossils() -> [Fossil] {
    return [
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
}

@Model
class Fossil {
    @Attribute(.unique) var id: UUID
    var name: String
    var part: String?
    var isDonated: Bool

    init(name: String, part: String? = nil, isDonated: Bool = false) {
        self.id = UUID()
        self.name = name
        self.part = part
        self.isDonated = isDonated
    }
}

struct FossilDetailView: View {
    var fossil: Fossil

    var body: some View {
        VStack(alignment: .leading) {
        
            if let part = fossil.part {
                Text("Part: \(part)")
                    .font(.title2)
            }
            
            Toggle("Donated", isOn: Binding(
                get: { fossil.isDonated },
                set: { newValue in
                    fossil.isDonated = newValue
                }
            ))
            .padding(.top)

            Spacer()  // Add some space for layout
        }
        .padding()
        .navigationTitle(fossil.name)
    }
}
