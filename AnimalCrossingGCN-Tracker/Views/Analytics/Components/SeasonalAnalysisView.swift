//
//  SeasonalAnalysisView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 11/11/25.
//

import SwiftUI
import Charts
import SwiftData

// Seasonal Analysis Chart
struct SeasonalAnalysisView: View {
    let seasonalData: SeasonalData
    @State private var selectedSeason: String?

    let monthColors: [String: Color] = [
        "Jan": .acWinterBlue,
        "Feb": .acWinterBlue,
        "Mar": .acLeafGreen,
        "Apr": .acLeafGreen,
        "May": .acLeafGreen,
        "Jun": .acBellYellow,
        "Jul": .acBellYellow,
        "Aug": .acBellYellow,
        "Sep": .acPumpkinOrange,
        "Oct": .acPumpkinOrange,
        "Nov": .acPumpkinOrange,
        "Dec": .acWinterBlue
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Seasonal Availability")
                .font(.title)
                .padding(.bottom, 4)

            // Current month highlight
            if let currentSeason = seasonalData.currentSeasonCompletion() {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Currently Available")
                        .font(.headline)

                    HStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("Bugs")
                                .font(.subheadline)
                            Text("\(currentSeason.bugDonated) of \(currentSeason.bugCount)")
                                .foregroundColor(.secondary)
                            ProgressView(value: currentSeason.bugProgress)
                                .tint(.green)
                        }

                        VStack(alignment: .leading) {
                            Text("Fish")
                                .font(.subheadline)
                            Text("\(currentSeason.fishDonated) of \(currentSeason.fishCount)")
                                .foregroundColor(.secondary)
                            ProgressView(value: currentSeason.fishProgress)
                                .tint(.acOceanBlue)
                        }
                    }
                    .padding()
                    .hierarchicalBackground()
                }
                .padding(.bottom)
            }

            // Monthly chart
            Chart {
                ForEach(seasonalData.seasonalCompletion) { season in
                    BarMark(
                        x: .value("Season", season.season),
                        y: .value("Bugs", season.bugCount)
                    )
                    .foregroundStyle(Color.green)

                    BarMark(
                        x: .value("Season", season.season),
                        y: .value("Fish", season.fishCount)
                    )
                    .foregroundStyle(Color.acOceanBlue)
                }
            }
            .chartForegroundStyleScale([
                "Bugs": Color.green,
                "Fish": Color.acOceanBlue
            ])
            .chartLegend(position: .bottom)
            .frame(height: 200)
            .chartXAxis {
                AxisMarks { value in
                    let month = value.as(String.self) ?? ""
                    AxisValueLabel {
                        Text(month)
                            .foregroundColor(monthColors[month] ?? .primary)
                    }
                }
            }
            .padding(.bottom)

            // Seasonal completion details
            Text("Monthly Breakdown")
                .font(.headline)
                .padding(.bottom, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(seasonalData.seasonalCompletion) { season in
                        SeasonalCompletionCard(completion: season, color: monthColors[season.season] ?? .primary)
                            .frame(width: 160, height: 120)
                    }
                }
            }
        }
        .padding()
        .hierarchicalBackground(level: .tertiary, cornerRadius: 12)
        .shadow(radius: 2)
    }
}
