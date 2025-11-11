//
//  HomeHeaderView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 11/11/25.
//

import SwiftUI
import SwiftData

/// Header view with town information and settings
struct HomeHeaderView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var isEditingTown: Bool
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(dataManager.currentTown?.name ?? "My Town")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text("Mayor: \(dataManager.currentTown?.playerName ?? "Player")")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            HStack(spacing: 12) {
                Button(action: {
                    isEditingTown = true
                }) {
                    Text("Edit")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.acLeafGreen)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }

                Button(action: {
                    // Settings action
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.acLeafGreen)
                }
            }
        }
        .padding()
        .background(Color.acLeafGreen.opacity(0.2))
        .cornerRadius(10)
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: Date())
    }
}
