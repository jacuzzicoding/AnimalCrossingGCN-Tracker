//
//  FishDetailView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock on 2/25/25.
//

import SwiftUI
import SwiftData

struct FishDetailView: View {
    var fish: Fish
    
    // Extract binding as computed property to maintain exact implementation
    private var donationBinding: Binding<Bool> {
        Binding(
            get: { fish.isDonated },
            set: { newValue in
                if newValue {
                    fish.isDonated = true
                    fish.donationDate = Date()
                    print("Debug: Setting donation date to \(Date())")
                } else {
                    fish.isDonated = false
                    fish.donationDate = nil
                    print("Debug: Clearing donation date")
                }
            }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Season: \(fish.season)")
                .font(.title2)
            
            Text("Location: \(fish.location)")
            
            if let donationDate = fish.formattedDonationDate {
                Text("Donated: \(donationDate)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Toggle("Donated", isOn: donationBinding)
                .padding(.top)
            
            DetailMoreInfoView(item: fish)
            
            Spacer()
        }
        .padding()
        .navigationTitle(fish.name)
    }
}

// Preview provider
#Preview {
    // Create a proper SwiftData container for previews
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Fish.self, configurations: config)
    
    // Create a preview instance with sample data
    let fish = Fish(
        name: "Sea Bass",
        season: "All Year",
        location: "Ocean",
        isDonated: false,
        games: [.ACGCN]
    )
    
    // Insert the fish into the preview context
    container.mainContext.insert(fish)
    
    return FishDetailView(fish: fish)
        .modelContainer(container)
}
