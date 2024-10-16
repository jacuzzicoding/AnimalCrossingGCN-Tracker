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
        Bug(name: "Common Butterfly", season: "March - October", isDonated: false),
        Bug(name: "Clouded Yellow Butterfly", season: "March - October", isDonated: false),
        Bug(name: "Tiger Swallowtail Butterfly", season: "April - September", isDonated: false),
        Bug(name: "Purple Butterfly", season: "June - July", isDonated: false),
        Bug(name: "Brown Cicada", season: "July - August", isDonated: false),
        Bug(name: "Robust Cicada", season: "July - August", isDonated: false),
        Bug(name: "Walker Cicada", season: "July - August", isDonated: false),
        Bug(name: "Evening Cicada", season: "July - August", isDonated: false),
        Bug(name: "Red Dragonfly", season: "September - October", isDonated: false),
        Bug(name: "Common Dragonfly", season: "May - July", isDonated: false),
        Bug(name: "Darner Dragonfly", season: "June - August", isDonated: false),
        Bug(name: "Banded Dragonfly", season: "July - August", isDonated: false),
        Bug(name: "Cricket", season: "September - November", isDonated: false),
        Bug(name: "Grasshopper", season: "July - September", isDonated: false),
        Bug(name: "Pine Cricket", season: "September - October", isDonated: false),
        Bug(name: "Bell Cricket", season: "September - October", isDonated: false),
        Bug(name: "Ladybug", season: "March - June, October", isDonated: false),
        Bug(name: "Seven-spotted Ladybug", season: "March - June, August - October", isDonated: false),
        Bug(name: "Mantis", season: "August - October", isDonated: false),
        Bug(name: "Long Locust", season: "August - October", isDonated: false),
        Bug(name: "Migratory Locust", season: "September - November", isDonated: false),
        Bug(name: "Cockroach", season: "January - December", isDonated: false),
        Bug(name: "Bee", season: "January - December", isDonated: false),
        Bug(name: "Firefly", season: "June", isDonated: false),
        Bug(name: "Drone Beetle", season: "July - August", isDonated: false),
        Bug(name: "Longhorn Beetle", season: "June - August", isDonated: false),
        Bug(name: "Jewel Beetle", season: "July - August", isDonated: false),
        Bug(name: "Dynastid Beetle", season: "July - August", isDonated: false),
        Bug(name: "Flat Stag Beetle", season: "June - August", isDonated: false),
        Bug(name: "Saw Stag Beetle", season: "July - August", isDonated: false),
        Bug(name: "Mountain Stag Beetle", season: "July - August", isDonated: false),
        Bug(name: "Giant Beetle", season: "July - August", isDonated: false),
        Bug(name: "Pondskater", season: "June - September", isDonated: false),
        Bug(name: "Ant", season: "January - December", isDonated: false),
        Bug(name: "Pill Bug", season: "January - December", isDonated: false),
        Bug(name: "Mosquito", season: "June - September", isDonated: false),
        Bug(name: "Mole Cricket", season: "January - May, November - December", isDonated: false),
        Bug(name: "Spider", season: "April - September", isDonated: false),
        Bug(name: "Snail", season: "April - September", isDonated: false),
        Bug(name: "Bagworm", season: "January - March, October - December", isDonated: false)
    ]
}

@Model
class Bug: ObservableObject, Identifiable { //define the Bug class
    var id: UUID //define the id attribute, using UUID because it is unique!
    var name: String
    var season: String? //define the season attribute, using optional String because it may not be known (though it should be)
    var isDonated: Bool

    init(name: String, season: String, isDonated: Bool = false) { //initialize the Bug class
        self.id = UUID()//set the id to a new UUID
        self.name = name //set the name to the name passed in
        self.season = season //set the season to the season passed in
        self.isDonated = isDonated //set the isDonated to the isDonated passed in
    }
}

struct BugDetailView: View { //need to maybe make a seperate function for iphones.
    var bug: Bug

    var body: some View {
        VStack(alignment: .leading) { //create a vertical stack with leading alignment
            // Safely unwrap the optional season value
            Text("Season: \(bug.season ?? "N/A")")  //display the season of the bug, "??" means if the season is nil, it will  display "N/A"
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
