//
//  Fossil.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/5/24.
//  Updated by Brock on 2/26/25
//

import Foundation
import SwiftData

@Model
class Fossil: CollectibleItem, DonationTimestampable {
    // Properties
    @Attribute(.unique) var id: UUID
    var name: String
    var part: String?
    var isDonated: Bool
    var donationDate: Date?
    var gameRawValues: [String]  // Storage property for game enums
    
    // Town relationship
    @Relationship(inverse: \Town.fossils) var town: Town?
    
    // Computed property for games
    var games: [ACGame] {
        get {
            gameRawValues.compactMap { ACGame(rawValue: $0) }
        }
        set {
            gameRawValues = newValue.map { $0.rawValue }
        }
    }

    init(name: String, part: String? = nil, isDonated: Bool = false, games: [ACGame]) {
        self.id = UUID()
        self.name = name
        self.part = part
        self.isDonated = isDonated
        self.donationDate = nil
        self.gameRawValues = games.map { $0.rawValue }
    }
}

func getDefaultFossils() -> [Fossil] {
    return [
        Fossil(
            name: "T. Rex",
            part: "Skull",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "T. Rex",
            part: "Torso",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "T. Rex",
            part: "Tail",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Triceratops",
            part: "Skull", 
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Triceratops",
            part: "Torso",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Triceratops",
            part: "Tail",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Stegosaurus",
            part: "Skull",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Stegosaurus",
            part: "Torso",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Stegosaurus",
            part: "Tail",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Pteranodon",
            part: "Skull",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Pteranodon",
            part: "Left Wing",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Pteranodon",
            part: "Right Wing",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Plesiosaurus",
            part: "Skull",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Plesiosaurus",
            part: "Neck",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Plesiosaurus",
            part: "Torso",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Apatosaurus",
            part: "Skull",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Apatosaurus",
            part: "Torso",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Apatosaurus",
            part: "Tail",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Mammoth",
            part: "Skull",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Mammoth",
            part: "Torso",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Amber",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Ammonite",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Dinosaur Egg",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Dinosaur Track",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fossil(
            name: "Trilobite",
            isDonated: false,
            games: [.ACGCN]
        )
    ]
}
