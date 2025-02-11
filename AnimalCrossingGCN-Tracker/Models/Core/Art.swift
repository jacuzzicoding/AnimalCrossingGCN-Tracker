import Foundation
import SwiftData
import SwiftUI

@Model
class Art {
    @Attribute(.unique) var id: UUID
    var name: String
    var basedOn: String
    var isDonated: Bool
    var donationDate: Date?
    var gameRawValues: [String]
    
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
        self.isDonated = isDonated
        self.donationDate = nil
        self.gameRawValues = games.map { $0.rawValue }
    }
}

struct ArtDetailView: View {
    var art: Art

    var body: some View {
        VStack(alignment: .leading) {
            Text("Based on: \(art.basedOn)")
                .font(.subheadline)
                .foregroundColor(.primary)

            if let donationDate = art.formattedDonationDate {
                Text("Donated: \(donationDate)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Toggle("Donated", isOn: Binding(
                get: { art.isDonated },
                set: { newValue in
                    if newValue {
                        art.isDonated = true
                        art.donationDate = Date()
                        print("Debug: Donation date set to \(Date())")
                    } else {
                        art.isDonated = false
                        art.donationDate = nil
                        print("Debug: Donation date removed")
                    }
                }
            ))
            .padding(.top)

            DetailMoreInfoView(item: art)
            
            Spacer()
        }
        .padding()
        .navigationTitle(art.name)
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
