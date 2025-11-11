//
//  SeasonalCompletionCard.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 11/11/25.
//

import SwiftUI
import SwiftData

// Helper view for seasonal completion card
struct SeasonalCompletionCard: View {
    let completion: SeasonalCompletion
    let color: Color

    var body: some View {
        VStack(alignment: .leading) {
            Text(getMonthName(from: completion.season))
                .font(.headline)
                .foregroundColor(color)

            Spacer()

            HStack {
                Image(systemName: "ant.fill")
                Text("\(completion.bugDonated)/\(completion.bugCount)")
                    .font(.caption)
            }
            .foregroundColor(.green)

            HStack {
                Image(systemName: "fish.fill")
                Text("\(completion.fishDonated)/\(completion.fishCount)")
                    .font(.caption)
            }
            .foregroundColor(.acOceanBlue)

            Spacer()

            Text("Total: \(Int(completion.totalProgress * 100))%")
                .font(.caption)
                .bold()
        }
        .padding()
        .hierarchicalBackground()
    }

    private func getMonthName(from abbreviation: String) -> String {
        let monthNames = [
            "Jan": "January",
            "Feb": "February",
            "Mar": "March",
            "Apr": "April",
            "May": "May",
            "Jun": "June",
            "Jul": "July",
            "Aug": "August",
            "Sep": "September",
            "Oct": "October",
            "Nov": "November",
            "Dec": "December"
        ]

        return monthNames[abbreviation] ?? abbreviation
    }
}
