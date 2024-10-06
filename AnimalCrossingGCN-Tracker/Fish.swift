//
//  Fish.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/6/24.
//
import Foundation
import SwiftData
import SwiftUI

// This function returns the default array of Fish
func getDefaultFish() -> [Fish] {
    return [
        Fish(name: "Sea Bass", season: "All", isDonated: false)
    ]
}

@Model
class Fish {
    @Attribute(.unique) var id: UUID
    var name: String
    var season: String
    var isDonated: Bool

    init(name: String, season: String, isDonated: Bool = false) {
        self.id = UUID()
        self.name = name
        self.season = season
        self.isDonated = isDonated
    }
}

struct FishDetailView: View {
    var Fish: Fish

    var body: some View {
        VStack(alignment: .leading) {
            Text(Fish.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Season: \(Fish.season)")
                .font(.title2)
            
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

