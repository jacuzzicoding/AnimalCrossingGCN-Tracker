//
//  Art.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 10/5/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Art: DonationTimestampable {
    //Properties
    @Attribute(.unique) var id: UUID
    var name: String
    var basedOn: String
    //var imageName: String // this will store the name of the image file
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

    init(name: String, basedOn: String, isDonated: Bool = false, games: [ACGame]) {
        self.id = UUID()
        self.name = name
        self.basedOn = basedOn
        //self.imageName = imageName
        self.isDonated = isDonated
        self.donationDate = nil
        self.gameRawValues = games.map { $0.rawValue }
    }
}

struct ArtDetailView: View {
    @Bindable var art: Art

    var body: some View {
        CommonDetailView(item: art) {
            VStack(alignment: .leading, spacing: 12) {
                // Artwork details
                HStack {
                    Image(systemName: "paintpalette.fill")
                        .foregroundColor(.purple)
                        .font(.headline)
                    Text("Based on:")
                        .font(.headline)
                }
                .padding(.horizontal)
                
                Text(art.basedOn)
                    .font(.subheadline)
                    .padding(.horizontal)
                
                // Future image display
                // Once we have images, we can uncomment this
                /*
                VStack {
                    Text("Artwork Preview")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Image(art.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(8)
                }
                .padding()
                .background(Color.secondary.opacity(0.05))
                .cornerRadius(8)
                */
                
                // Game availability section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Available In:")
                        .font(.headline)
                    
                    HStack {
                        ForEach(art.games, id: \.self) { game in
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
            .padding(.bottom)
        }
    }
}

func getDefaultArt() -> [Art] {
    return [
        Art(
            name: "Academic Painting",
            basedOn: "Vitruvian Man by Leonardo da Vinci",
            isDonated: false,
            games: [.ACGCN]
        ),
        Art(
            name: "Amazing Painting",
            basedOn: "The Night Watch by Rembrandt",
            isDonated: false,
            games: [.ACGCN]
        ),
        Art(
            name: "Basic Painting",
            basedOn: "The Blue Boy by Thomas Gainsborough",
            isDonated: false,
            games: [.ACGCN]
        ),
        Art(
            name: "Calm Painting",
            basedOn: "A Sunday Afternoon on the Island of La Grande Jatte by Georges Seurat",
            isDonated: false,
            games: [.ACGCN]
        ),
        Art(
            name: "Classic Painting",
            basedOn: "Washington Crossing the Delaware by Emanuel Leutze",
            isDonated: false,
            games: [.ACGCN]
        ),
        Art(
            name: "Common Painting",
            basedOn: "The Gleaners by Jean-François Millet",
            isDonated: false,
            games: [.ACGCN]
        ),
        Art(
            name: "Dainty Painting",
            basedOn: "The Star (Dancer on Stage) by Edgar Degas",
            isDonated: false,
            games: [.ACGCN]
        ),
        Art(
            name: "Famous Painting",
            basedOn: "Mona Lisa by Leonardo da Vinci",
            isDonated: false,
            games: [.ACGCN]
        ),
        Art(
            name: "Flowery Painting",
            basedOn: "Sunflowers by Vincent van Gogh",
            isDonated: false,
            games: [.ACGCN]
        ),
        Art(
            name: "Moving Painting",
            basedOn: "The Birth of Venus by Sandro Botticelli",
            isDonated: false,
            games: [.ACGCN]
        ),
        Art(
            name: "Quaint Painting",
            basedOn: "The Milkmaid by Johannes Vermeer",
            isDonated: false,
            games: [.ACGCN]
        ),
        Art(
            name: "Scary Painting",
            basedOn: "Otani Oniji II by Toshusai Sharaku",
            isDonated: false,
            games: [.ACGCN]
        ),
        Art(
            name: "Worthy Painting",
            basedOn: "Liberty Leading the People by Eugène Delacroix",
            isDonated: false,
            games: [.ACGCN]
        )
    ]
}
