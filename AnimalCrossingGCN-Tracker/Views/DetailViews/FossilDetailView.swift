//
//  FossilDetailView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock on 2/25/25.
//

import SwiftUI
import SwiftData

struct FossilDetailView: View {
    var fossil: Fossil
    
    // Extract binding as computed property to maintain exact implementation
    private var donationBinding: Binding<Bool> {
        Binding(
            get: { fossil.isDonated },
            set: { newValue in
                if newValue {
                    fossil.isDonated = true
                    fossil.donationDate = Date()
                    print("Debug: Donation date set to \(Date())")
                } else {
                    fossil.isDonated = false
                    fossil.donationDate = nil
                    print("Debug: Donation date removed")
                }
            }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let part = fossil.part {
                Text("Part: \(part)")
                    .font(.title2)
            }
            
            if let donationDate = fossil.formattedDonationDate {
                Text("Donated: \(donationDate)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Toggle("Donated", isOn: donationBinding)
                .padding(.top)
            
            DetailMoreInfoView(item: fossil)
            
            Spacer()
        }
        .padding()
        .navigationTitle(fossil.name)
    }
}

// Preview provider
#Preview {
    // Create a proper SwiftData container for previews
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Fossil.self, configurations: config)
    
    // Create a preview instance with sample data
    let fossil = Fossil(
        name: "T. Rex Skull",
        part: "Skull",
        isDonated: false,
        games: [.ACGCN]
    )
    
    // Insert the fossil into the preview context
    container.mainContext.insert(fossil)
    
    return FossilDetailView(fossil: fossil)
        .modelContainer(container)
}
