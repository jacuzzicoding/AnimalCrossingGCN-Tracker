//
//  ArtDetailView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock on 2/25/25.
//

import SwiftUI
import SwiftData

struct ArtDetailView: View {
    var art: Art
    
    // Extract binding as computed property to maintain exact implementation
    private var donationBinding: Binding<Bool> {
        Binding(
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
        )
    }
    
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
            
            // I will uncomment this once we have images in the assets folder
            // Image(art.imageName)
            //     .resizable()
            //     .scaledToFit()
            //     .frame(height: 200)
            //     .cornerRadius(8)
            //     .padding(.top)
            
            Toggle("Donated", isOn: donationBinding)
                .padding(.top)
            
            DetailMoreInfoView(item: art)
            
            Spacer()
        }
        .padding()
        .navigationTitle(art.name)
    }
}

// Preview provider
#Preview {
    // Create a proper SwiftData container for previews
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Art.self, configurations: config)
    
    // Create a preview instance with sample data
    let art = Art(
        name: "Famous Painting",
        basedOn: "Mona Lisa by Leonardo da Vinci",
        isDonated: false,
        games: [.ACGCN]
    )
    
    // Insert the art into the preview context
    container.mainContext.insert(art)
    
    return ArtDetailView(art: art)
        .modelContainer(container)
}
