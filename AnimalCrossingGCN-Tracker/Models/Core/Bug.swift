//
//  Bug.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/5/24.
//
import Foundation
import SwiftData
import SwiftUI

@Model
class Bug: DonationTimestampable {
    //Properties
    @Attribute(.unique) var id: UUID
    var name: String
    var season: String?
    var isDonated: Bool
    var donationDate: Date?
    var gameRawValues: [String]
    
    // Computed property to access ACGame enums
    var games: [ACGame] {
        get {
            gameRawValues.compactMap { ACGame(rawValue: $0) }
        }
        set {
            gameRawValues = newValue.map { $0.rawValue }
        }
    }

    init(name: String, season: String, isDonated: Bool = false, games: [ACGame]) {
        self.id = UUID()
        self.name = name
        self.season = season
        self.isDonated = isDonated
        self.donationDate = nil
        self.gameRawValues = games.map { $0.rawValue }
    }
}

struct BugDetailView: View {
    @Bindable var bug: Bug

    var body: some View {
        CommonDetailView(item: $bug) {
            VStack(alignment: .leading, spacing: 12) {
                // Season information
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.green)
                        .font(.headline)
                    Text("Season: \(bug.season ?? "Unknown")")
                        .font(.headline)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                
                // Game availability section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Available In:")
                        .font(.headline)
                    
                    HStack {
                        ForEach(bug.games, id: \.self) { game in
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

func getDefaultBugs() -> [Bug] {
    return [
        Bug(
            name: "Common Butterfly",
            season: "March - October",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Clouded Yellow Butterfly",
            season: "March - October",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Tiger Swallowtail Butterfly",
            season: "April - September",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Purple Butterfly",
            season: "June - July",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Brown Cicada",
            season: "July - August",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Robust Cicada",
            season: "July - August",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Walker Cicada",
            season: "July - August",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Evening Cicada",
            season: "July - August",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Red Dragonfly",
            season: "September - October",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Common Dragonfly",
            season: "May - July",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Darner Dragonfly",
            season: "June - August",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Banded Dragonfly",
            season: "July - August",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Cricket",
            season: "September - November",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Grasshopper",
            season: "July - September",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Pine Cricket",
            season: "September - October",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Bell Cricket",
            season: "September - October",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Ladybug",
            season: "March - June, October",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Seven-spotted Ladybug",
            season: "March - June, August - October",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Mantis",
            season: "August - October",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Long Locust",
            season: "August - October",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Migratory Locust",
            season: "September - November",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Cockroach",
            season: "January - December",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Bee",
            season: "January - December",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Firefly",
            season: "June",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Drone Beetle",
            season: "July - August",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Longhorn Beetle",
            season: "June - August",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Jewel Beetle",
            season: "July - August",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Dynastid Beetle",
            season: "July - August",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Flat Stag Beetle",
            season: "June - August",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Saw Stag Beetle",
            season: "July - August",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Mountain Stag Beetle",
            season: "July - August",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Giant Beetle",
            season: "July - August",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Pondskater",
            season: "June - September",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Ant",
            season: "January - December",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Pill Bug",
            season: "January - December",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Mosquito",
            season: "June - September",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Mole Cricket",
            season: "January - May, November - December",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Spider",
            season: "April - September",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Snail",
            season: "April - September",
            isDonated: false,
            games: [.ACGCN]
        ),
        Bug(
            name: "Bagworm",
            season: "January - March, October - December",
            isDonated: false,
            games: [.ACGCN]
        )
    ]
}
