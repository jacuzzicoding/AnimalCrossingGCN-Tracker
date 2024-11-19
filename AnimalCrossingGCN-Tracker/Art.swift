//
//  Art.swift
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Art: ObservableObject, Identifiable {
    var id: UUID
    var name: String
    var basedOn: String  // this field is for the real-world counterpart name and artist
    //var imageName: String // this will store the name of the image file
    var isDonated: Bool

    init(name: String, basedOn: String, isDonated: Bool = false) { //include imageName: String here once fixed
        self.id = UUID()
        self.name = name
        self.basedOn = basedOn
      //  self.imageName = imageName
        self.isDonated = isDonated
    }
}

struct ArtDetailView: View {
    var art: Art

    var body: some View {
        VStack(alignment: .leading) {

            Text("Based on: \(art.basedOn)")
                .font(.subheadline)
                .foregroundColor(.primary)

            // I will uncomment this once we have images in the assets folder, just putting in the framework for now
            // Image(art.imageName)
            //     .resizable()
            //     .scaledToFit()
            //     .frame(height: 200)
            //     .cornerRadius(8)
            //     .padding(.top)

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

// This function returns the array of art pieces
func getDefaultArt() -> [Art] {
    return [
        Art(name: "Academic Painting", basedOn: "Vitruvian Man by Leonardo da Vinci", isDonated: false),
        Art(name: "Amazing Painting", basedOn: "The Night Watch by Rembrandt", isDonated: false),
        Art(name: "Basic Painting", basedOn: "The Blue Boy by Thomas Gainsborough", isDonated: false),
        Art(name: "Calm Painting", basedOn: "A Sunday Afternoon on the Island of La Grande Jatte by Georges Seurat", isDonated: false),
        Art(name: "Classic Painting", basedOn: "Washington Crossing the Delaware by Emanuel Leutze", isDonated: false),
        Art(name: "Common Painting", basedOn: "The Gleaners by Jean-François Millet", isDonated: false),
        Art(name: "Dainty Painting", basedOn: "The Star (Dancer on Stage) by Edgar Degas", isDonated: false),
        Art(name: "Famous Painting", basedOn: "Mona Lisa by Leonardo da Vinci", isDonated: false),
        Art(name: "Flowery Painting", basedOn: "Sunflowers by Vincent van Gogh", isDonated: false),
        Art(name: "Moving Painting", basedOn: "The Birth of Venus by Sandro Botticelli", isDonated: false),
        Art(name: "Quaint Painting", basedOn: "The Milkmaid by Johannes Vermeer", isDonated: false),
        Art(name: "Scary Painting", basedOn: "Otani Oniji II by Toshusai Sharaku", isDonated: false),
        Art(name: "Worthy Painting", basedOn: "Liberty Leading the People by Eugène Delacroix", isDonated: false)
    ]
}