//
//  Bug.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/5/24.
//
import Foundation
import SwiftData
import SwiftUI

// This function returns the default array of bugs
func getDefaultBugs() -> [Bug] {
    return [
        Bug(name: "Common Butterfly", season: "March - June", isDonated: false),
        Bug(name: "Emperor Butterfly", season: "June - September", isDonated: false),
        Bug(name: "Dung Beetle", season: "December - February", isDonated: false),
        Bug(name: "Honeybee", season: "March - July", isDonated: false),
        // Add more bugs here
    ]
}

@Model
class Bug {
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

struct BugDetailView: View {
    var bug: Bug

    var body: some View {
        VStack(alignment: .leading) {
            Text(bug.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Season: \(bug.season)")
                .font(.title2)
            
            Toggle("Donated", isOn: Binding(
                get: { bug.isDonated },
                set: { newValue in
                    bug.isDonated = newValue
                }
            ))
            .padding(.top)

            Spacer()
        }
        .padding()
        .navigationTitle(bug.name)
    }
}
