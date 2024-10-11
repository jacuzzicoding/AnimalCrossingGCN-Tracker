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
        Art(name: "Academic Painting", isDonated: false),
        Art(name: "Amazing Painting", isDonated: false),
        Art(name: "Basic Painting", isDonated: false),
        Art(name: "Calm Painting", isDonated: false),
        // Add more art pieces here...
    ]
}

@Model
class Art: ObservableObject, Identifiable {
    var id: UUID
    var name: String
    var isDonated: Bool

    init(name: String, isDonated: Bool = false) {
        self.id = UUID()
        self.name = name
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
