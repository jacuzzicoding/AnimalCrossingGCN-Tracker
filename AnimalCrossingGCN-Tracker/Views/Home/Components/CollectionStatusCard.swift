//
//  CollectionStatusCard.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 11/11/25.
//

import SwiftUI
import SwiftData

/// Card showing overall collection status
struct CollectionStatusCard: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "building.columns.fill")
                    .foregroundColor(.acLeafGreen)
                    .font(.headline)
                Text("Museum Collection Status")
                    .font(.headline)
                    .foregroundColor(.black)
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 20)
                        .opacity(0.2)
                        .foregroundColor(Color.acLeafGreen)
                        .cornerRadius(10)

                    Rectangle()
                        .frame(width: min(CGFloat(dataManager.getCurrentTownProgress()) * geometry.size.width, geometry.size.width), height: 20)
                        .foregroundColor(Color.acLeafGreen)
                        .cornerRadius(10)
                        .animation(.easeInOut, value: dataManager.getCurrentTownProgress())

                    HStack {
                        Spacer()
                        Text("\(Int(dataManager.getCurrentTownProgress() * 100))%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.trailing, 10)
                    }
                }
            }
            .frame(height: 20)

            // Total count
            HStack {
                let completion: CategoryCompletionData? = {
                    do {
                        return try dataManager.getCategoryCompletionData()
                    } catch {
                        print("Error fetching category completion data: \(error)")
                        return nil
                    }
                }()
                if let completion = completion {
                    Text("\(completion.totalDonated) of \(completion.totalCount) Items Donated")
                        .font(.subheadline)
                        .foregroundColor(.black)
                } else {
                    Text("0 of 0 Items Donated")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }

                Spacer()
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Museum Collection Status: \(Int(dataManager.getCurrentTownProgress() * 100))% complete")
}
}
