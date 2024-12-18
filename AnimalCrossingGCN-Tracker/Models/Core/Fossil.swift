//
//  Fossil.swift
//
import Foundation
import SwiftData
import SwiftUI

@Model
class Fossil {
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
//conform to DonationTimestampable
extension Fossil: DonationTimestampable { }

// Detail view for Fossil
struct FossilDetailView: View {
    var fossil: Fossil

    var body: some View {
        VStack(alignment: .leading) {
            if let part = fossil.part {
                Text("Part: \(part)")
                    .font(.title2)
            }
            //store the donation date
            if let donationDate = fossil.formattedDonationDate {
                Text("Donated: \(donationDate)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Toggle("Donated", isOn: Binding(
                get: { fossil.isDonated },
                set: { newValue in
                    fossil.isDonated = newValue
                }
            ))
            .padding(.top)

            DetailMoreInfoView(item: fossil) //the more info button

            Spacer()
        }
        .padding()
        .navigationTitle(fossil.name)
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