//
//  Fish.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/6/24.
//
import Foundation
import SwiftData
import SwiftUI

@Model
class Fish {
    @Attribute(.unique) var id: UUID
    var name: String
    var season: String
    var location: String
    var isDonated: Bool
    var games: [String] //new attribute to the model, this will be used to store the games that the fish is in

init(name: String, season: String, location: String, isDonated: Bool = false, games: [String]) { //init for the model, this is used when creating a new instance of the model
        self.id = UUID()
        self.name = name
        self.season = season
        self.location = location
        self.isDonated = isDonated
        self.games = games 
    }
}
// Helper enum for type safety when adding games
enum ACGame: String {
    case gameCube = "ACGCN" //Animal Crossing on the GameCube (Population Growing)
    case wildWorld = "ACWW" //Animal Crossing Wild World
    case cityFolk = "ACCF" //Animal Crossing City Folk
    case newLeaf = "ACNL" //Animal Crossing New Leaf
    case newHorizons = "ACNH" //Animal Crossing New Horizons
}

struct FishDetailView: View {
    var Fish: Fish

    var body: some View {
        VStack(alignment: .leading) {
        
            
            Text("Season: \(Fish.season)")
                .font(.title2)
            
            Text("Location: \(Fish.location)")
                
            
            Toggle("Donated", isOn: Binding(
                get: { Fish.isDonated },
                set: { newValue in
                    Fish.isDonated = newValue
                }
            ))
            .padding(.top)

            Spacer()
        }
        .padding()
        .navigationTitle(Fish.name)
    }
}

func getDefaultFish() -> [Fish] {
    return [
        Fish(name: "Sea Bass", season: "All", location: "Sea", isDonated: false),
        Fish(name: "Brook Trout", season: "All", location: "Lake", isDonated: false),
        Fish(name: "Crucian Carp", season: "All", location: "River", isDonated: false),
        Fish(name: "Carp", season: "All", location: "River", isDonated: false),
        Fish(name: "Koi", season: "All", location: "River", isDonated: false),
        Fish(name: "Barbel Steed", season: "All", location: "River", isDonated: false),
        Fish(name: "Dace", season: "All", location: "River", isDonated: false),
        Fish(name: "Catfish", season: "June - September", location: "River", isDonated: false),
        Fish(name: "Giant Catfish", season: "July - August", location: "Lake", isDonated: false),
        Fish(name: "Pale Chub", season: "All", location: "River", isDonated: false),
        Fish(name: "Bitterling", season: "November - February", location: "River", isDonated: false),
        Fish(name: "Loach", season: "March - May", location: "River", isDonated: false),
        Fish(name: "Bluegill", season: "All", location: "River", isDonated: false),
        Fish(name: "Small Bass", season: "All", location: "River", isDonated: false),
        Fish(name: "Bass", season: "All", location: "River", isDonated: false),
        Fish(name: "Large Bass", season: "All", location: "River", isDonated: false),
        Fish(name: "Giant Snakehead", season: "July - August", location: "Lake", isDonated: false),
        Fish(name: "Eel", season: "September - October", location: "River", isDonated: false),
        Fish(name: "Freshwater Goby", season: "All", location: "River", isDonated: false),
        Fish(name: "Pond Smelt", season: "December - February", location: "River", isDonated: false),
        Fish(name: "Sweetfish", season: "July - September", location: "River", isDonated: false),
        Fish(name: "Cherry Salmon", season: "March - June, September - November", location: "River", isDonated: false),
        Fish(name: "Rainbow Trout", season: "March - June", location: "River", isDonated: false),
        Fish(name: "Stringfish", season: "December - February", location: "River", isDonated: false),
        Fish(name: "Salmon", season: "September", location: "River (mouth)", isDonated: false),
        Fish(name: "Goldfish", season: "All", location: "River", isDonated: false),
        Fish(name: "Pop-eyed Goldfish", season: "All", location: "River", isDonated: false),
        Fish(name: "Guppy", season: "April - November", location: "River", isDonated: false),
        Fish(name: "Angelfish", season: "May - October", location: "River", isDonated: false),
        Fish(name: "Piranha", season: "June - September", location: "River", isDonated: false),
        Fish(name: "Arowana", season: "June - September", location: "River", isDonated: false),
        Fish(name: "Coelacanth", season: "All (raining)", location: "Sea", isDonated: false),
        Fish(name: "Crawfish", season: "April - September", location: "Pond", isDonated: false),
        Fish(name: "Frog", season: "May - August", location: "Pond", isDonated: false),
        Fish(name: "Killifish", season: "April - August", location: "River", isDonated: false),
        Fish(name: "Jellyfish", season: "August", location: "Sea", isDonated: false),
        Fish(name: "Red Snapper", season: "All", location: "Sea", isDonated: false),
        Fish(name: "Barred Knifejaw", season: "March - November", location: "Sea", isDonated: false),
        Fish(name: "Arapaima", season: "July - September", location: "River", isDonated: false),
        Fish(name: "Squid", season: "December - August", location: "Sea", isDonated: false)
    ]
}