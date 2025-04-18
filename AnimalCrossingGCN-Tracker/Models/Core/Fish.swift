//
//  Fish.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/6/24.
//  Updated by Brock on 2/26/25
//

import Foundation
import SwiftData

@Model
class Fish: CollectibleItem, DonationTimestampable {
    //Properties
    @Attribute(.unique) var id: UUID
    var name: String
    var season: String
    var location: String
    var isDonated: Bool
    var donationDate: Date?
    var gameRawValues: [String]
    
    // Store the town ID rather than a direct relationship
    var townId: UUID?
    
    // Computed property to access ACGame enums
    var games: [ACGame] {
        get {
            gameRawValues.compactMap { ACGame(rawValue: $0) }
        }
        set {
            gameRawValues = newValue.map { $0.rawValue }
        }
    }

    init(name: String, season: String, location: String, isDonated: Bool = false, games: [ACGame]) {
        self.id = UUID()
        self.name = name
        self.season = season
        self.location = location
        self.isDonated = isDonated
        self.donationDate = nil
        self.gameRawValues = games.map { $0.rawValue }
    }
}

func getDefaultFish() -> [Fish] {
    return [
        Fish(
            name: "Sea Bass",
            season: "All",
            location: "Sea",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Brook Trout",
            season: "All",
            location: "Lake",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Crucian Carp",
            season: "All",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Carp",
            season: "All",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Koi",
            season: "All",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Barbel Steed",
            season: "All",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Dace",
            season: "All",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Catfish",
            season: "June - September",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Giant Catfish",
            season: "July - August",
            location: "Lake",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Pale Chub",
            season: "All",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Bitterling",
            season: "November - February",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Loach",
            season: "March - May",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Bluegill",
            season: "All",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Small Bass",
            season: "All",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Bass",
            season: "All",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Large Bass",
            season: "All",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Giant Snakehead",
            season: "July - August",
            location: "Lake",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Eel",
            season: "September - October",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Freshwater Goby",
            season: "All",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Pond Smelt",
            season: "December - February",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Sweetfish",
            season: "July - September",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Cherry Salmon",
            season: "March - June, September - November",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Rainbow Trout",
            season: "March - June",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Stringfish",
            season: "December - February",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Salmon",
            season: "September",
            location: "River (mouth)",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Goldfish",
            season: "All",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Pop-eyed Goldfish",
            season: "All",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Guppy",
            season: "April - November",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Angelfish",
            season: "May - October",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Piranha",
            season: "June - September",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Arowana",
            season: "June - September",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Coelacanth",
            season: "All (raining)",
            location: "Sea",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Crawfish",
            season: "April - September",
            location: "Pond",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Frog",
            season: "May - August",
            location: "Pond",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Killifish",
            season: "April - August",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Jellyfish",
            season: "August",
            location: "Sea",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Red Snapper",
            season: "All",
            location: "Sea",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Barred Knifejaw",
            season: "March - November",
            location: "Sea",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Arapaima",
            season: "July - September",
            location: "River",
            isDonated: false,
            games: [.ACGCN]
        ),
        Fish(
            name: "Squid",
            season: "December - August",
            location: "Sea",
            isDonated: false,
            games: [.ACGCN]
        )
    ]
}
