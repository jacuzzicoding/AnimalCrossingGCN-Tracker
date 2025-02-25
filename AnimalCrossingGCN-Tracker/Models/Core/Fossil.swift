//
//  Fossil.swift
//
import Foundation
import SwiftData
import SwiftUI

@Model
class Fossil: DonationTimestampable {
    //Properties
    @Attribute(.unique) var id: UUID
    var name: String
    var part: String?
    var isDonated: Bool
    var donationDate: Date?
    var gameRawValues: [String]  // New storage property
    
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

struct FossilDetailView: View {
    @Bindable var fossil: Fossil

    var body: some View {
        CommonDetailView(item: fossil) {
            VStack(alignment: .leading, spacing: 12) {
                if let part = fossil.part {
                    HStack {
                        Image(systemName: "fossil.shell.fill")
                            .foregroundColor(.brown)
                            .font(.headline)
                        Text("Part: \(part)")
                            .font(.headline)
                    }
                    .padding()
                    .background(Color.brown.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Game availability section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Available In:")
                        .font(.headline)
                    
                    HStack {
                        ForEach(fossil.games, id: \.self) { game in
                            VStack {
                                Image(systemName: game.icon)
                                Text(game.shortName)
                                    .font(.caption)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(Color.secondary.opacity(0.05))
                .cornerRadius(8)
            }
        }
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
