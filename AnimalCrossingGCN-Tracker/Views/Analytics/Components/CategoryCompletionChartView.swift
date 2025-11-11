//
//  CategoryCompletionChartView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 11/11/25.
//

import SwiftUI
import Charts
import SwiftData

// Category Completion Chart
struct CategoryCompletionChartView: View {
    let completionData: CategoryCompletionData

    var body: some View {
        VStack(alignment: .leading) {
            Text("Museum Completion")
                .font(.title)
                .padding(.bottom, 4)

            VStack(spacing: 20) {
                // Overall progress
                VStack(alignment: .leading) {
                    HStack {
                        Text("Overall Progress")
                            .font(.headline)
                        Spacer()
                        Text("\(Int(completionData.totalProgress * 100))%")
                            .bold()
                    }

                    ProgressView(value: completionData.totalProgress)
                        .tint(.acLeafGreen)

                    Text("\(completionData.totalDonated) of \(completionData.totalCount) items donated")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                // Category breakdown
                VStack(alignment: .leading, spacing: 12) {
                    Text("Categories")
                        .font(.headline)

                    // Pie chart
                    Chart {
                        SectorMark(
                            angle: .value("Fossils", completionData.fossilCount),
                            innerRadius: .ratio(0.6),
                            angularInset: 1.5
                        )
                        .foregroundStyle(Color.acMuseumBrown)
                        .opacity(0.8)

                        SectorMark(
                            angle: .value("Bugs", completionData.bugCount),
                            innerRadius: .ratio(0.6),
                            angularInset: 1.5
                        )
                        .foregroundStyle(Color.green)
                        .opacity(0.8)

                        SectorMark(
                            angle: .value("Fish", completionData.fishCount),
                            innerRadius: .ratio(0.6),
                            angularInset: 1.5
                        )
                        .foregroundStyle(Color.acOceanBlue)
                        .opacity(0.8)

                        SectorMark(
                            angle: .value("Art", completionData.artCount),
                            innerRadius: .ratio(0.6),
                            angularInset: 1.5
                        )
                        .foregroundStyle(Color.acBlathersPurple)
                        .opacity(0.8)
                    }
                    .frame(height: 200)
                    .chartLegend(position: .bottom)

                    // Progress bars for each category
                    CategoryProgressView(
                        label: "Fossils",
                        progress: completionData.fossilProgress,
                        donated: completionData.fossilDonated,
                        total: completionData.fossilCount,
                        color: .acMuseumBrown
                    )

                    CategoryProgressView(
                        label: "Bugs",
                        progress: completionData.bugProgress,
                        donated: completionData.bugDonated,
                        total: completionData.bugCount,
                        color: .green
                    )

                    CategoryProgressView(
                        label: "Fish",
                        progress: completionData.fishProgress,
                        donated: completionData.fishDonated,
                        total: completionData.fishCount,
                        color: .acOceanBlue
                    )

                    CategoryProgressView(
                        label: "Art",
                        progress: completionData.artProgress,
                        donated: completionData.artDonated,
                        total: completionData.artCount,
                        color: .acBlathersPurple
                    )
                }
            }
        }
        .padding()
        .hierarchicalBackground(level: .tertiary, cornerRadius: 12)
        .shadow(radius: 2)
    }
}
