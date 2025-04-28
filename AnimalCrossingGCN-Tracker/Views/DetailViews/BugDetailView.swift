//
//  BugDetailView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock on 2/25/25.
//

import SwiftUI
import SwiftData

struct BugDetailView: View {
    var bug: Bug
    
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Season: \(bug.season ?? "N/A")")
                .font(.title2)
            
            if let donationDate = bug.formattedDonationDate {
                Text("Donated: \(donationDate)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Toggle("Donated", isOn: Binding(
                get: { bug.isDonated },
                set: { newValue in
                    dataManager.updateBugDonationStatus(bug, isDonated: newValue)
                }
            ))
            .padding(.top)
            
            DetailMoreInfoView(item: bug)
            
            Spacer()
        }
        .padding()
        .navigationTitle(bug.name)
    }
}

// Preview provider
#Preview {
    // Create a proper SwiftData container for previews
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Bug.self, configurations: config)
    
    // Create a preview instance with sample data
    let bug = Bug(
        name: "Common Butterfly",
        season: "March - October",
        isDonated: false,
        games: [.ACGCN]
    )
    
    // Insert the bug into the preview context
    container.mainContext.insert(bug)
    
    return BugDetailView(bug: bug)
        .modelContainer(container)
}
