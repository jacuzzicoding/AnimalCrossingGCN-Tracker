//
//  Art.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/11/24.
//

import Foundation
import SwiftData
import SwiftUI

// This function returns the default array of art pieces
func getDefaultArt() -> [Art] {
    return [
        Art(name: "Academic Painting", basedOn: "Vitruvian Man", isDonated: false),
        Art(name: "Amazing Painting", basedOn: "The Night Watch", isDonated: false),
        Art(name: "Basic Painting", basedOn: "The Blue Boy", isDonated: false),
        Art(name: "Calm Painting", basedOn: "A Sunday Afternoon on the Island of La Grande Jatte", isDonated: false),
        Art(name: "Classic Painting", basedOn: "Washington Crossing the Delaware", isDonated: false),
        Art(name: "Common Painting", basedOn: "The Gleaners", isDonated: false),
        Art(name: "Dainty Painting", basedOn: "The Star (Dancer on Stage)", isDonated: false),
        Art(name: "Famous Painting", basedOn: "Mona Lisa", isDonated: false),
        Art(name: "Flowery Painting", basedOn: "Sunflowers", isDonated: false),
        Art(name: "Moving Painting", basedOn: "The Birth of Venus", isDonated: false),
        Art(name: "Quaint Painting", basedOn: "The Milkmaid", isDonated: false),
        Art(name: "Scary Painting", basedOn: "Otani Oniji II", isDonated: false),
        Art(name: "Worthy Painting", basedOn: "Liberty Leading the People", isDonated: false)
    ]
}

@Model
class Art: ObservableObject, Identifiable {
    var id: UUID
    var name: String
    var basedOn: String  // New field for real-world counterpart
    var isDonated: Bool

    init(name: String, basedOn: String, isDonated: Bool = false) {
        self.id = UUID()
        self.name = name
        self.basedOn = basedOn  // Initialize the basedOn field
        self.isDonated = isDonated
    }
}

struct ArtDetailView: View {
    var art: Art

    var body: some View {
        VStack(alignment: .leading) {
            Text(art.name)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Based on: \(art.basedOn)")  // Display the real-world painting
                .font(.subheadline)
                .foregroundColor(.secondary)

            Toggle("Donated", isOn: Binding(
                get: { art.isDonated },
                set: { newValue in
                    art.isDonated = newValue
                }
            ))
            .padding(.top)

            Spacer()
        }
        .padding()
        .navigationTitle(art.name)
    }
}
