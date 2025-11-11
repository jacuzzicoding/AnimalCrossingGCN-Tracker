//
//  DonationTimelineView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 11/11/25.
//

import SwiftUI
import Charts
import SwiftData

// Timeline Chart View
struct DonationTimelineView: View {
    let timelineData: [MonthlyDonationActivity]
    @State private var selectedTimeFrame: TimeFrame = .all

    enum TimeFrame: String, CaseIterable, Identifiable {
        case quarter = "3 Months"
        case halfYear = "6 Months"
        case year = "1 Year"
        case all = "All Time"

        var id: String { self.rawValue }
    }

    var filteredData: [MonthlyDonationActivity] {
        guard !timelineData.isEmpty else { return [] }

        let calendar = Calendar.current
        let now = Date()

        switch selectedTimeFrame {
        case .quarter:
            let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: now)!
            let filtered = timelineData.filter { $0.month >= threeMonthsAgo }
            return filtered.isEmpty ? timelineData : filtered
        case .halfYear:
            let sixMonthsAgo = calendar.date(byAdding: .month, value: -6, to: now)!
            let filtered = timelineData.filter { $0.month >= sixMonthsAgo }
            return filtered.isEmpty ? timelineData : filtered
        case .year:
            let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: now)!
            let filtered = timelineData.filter { $0.month >= oneYearAgo }
            return filtered.isEmpty ? timelineData : filtered
        case .all:
            return timelineData
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Donation Timeline")
                .font(.title)
                .padding(.bottom, 4)

            Picker("Time Frame", selection: $selectedTimeFrame) {
                ForEach(TimeFrame.allCases) { timeFrame in
                    Text(timeFrame.rawValue).tag(timeFrame)
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom)

            if filteredData.isEmpty {
                VStack {
                    Spacer()
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary.opacity(0.5))
                        .padding(.bottom, 8)
                    Text("No donation data available for this time period")
                        .foregroundColor(.secondary)
                    Text("Try selecting a different time period or donate more items")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: 300)
                .hierarchicalBackground()
            } else {
                VStack {
                    Chart {
                        ForEach(filteredData) { activity in
                            BarMark(
                                x: .value("Month", activity.formattedMonth),
                                y: .value("Fossils", activity.fossilCount)
                            )
                            .foregroundStyle(Color.acMuseumBrown)

                            BarMark(
                                x: .value("Month", activity.formattedMonth),
                                y: .value("Bugs", activity.bugCount)
                            )
                            .foregroundStyle(Color.green)

                            BarMark(
                                x: .value("Month", activity.formattedMonth),
                                y: .value("Fish", activity.fishCount)
                            )
                            .foregroundStyle(Color.acOceanBlue)

                            BarMark(
                                x: .value("Month", activity.formattedMonth),
                                y: .value("Art", activity.artCount)
                            )
                            .foregroundStyle(Color.acBlathersPurple)
                        }
                    }
                    .chartForegroundStyleScale([
                        "Fossils": Color.acMuseumBrown,
                        "Bugs": Color.green,
                        "Fish": Color.acOceanBlue,
                        "Art": Color.acBlathersPurple
                    ])
                    .chartLegend(position: .bottom, alignment: .center)
                    .chartXAxis {
                        AxisMarks(preset: .aligned, values: .automatic) { value in
                            if let month = value.as(String.self) {
                                // Only show every other month label when many months are displayed
                                if filteredData.count > 6 && filteredData.firstIndex(where: { $0.formattedMonth == month })! % 2 != 0 {
                                    AxisValueLabel {
                                        Text(" ")
                                    }
                                } else {
                                    let components = month.components(separatedBy: " ")
                                    AxisValueLabel {
                                        VStack {
                                            if components.count > 1 {
                                                Text(components[0].prefix(3))
                                                Text(components[1])
                                                    .font(.caption)
                                            } else {
                                                Text(month)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Show total donations
                    if !filteredData.isEmpty {
                        let total = filteredData.reduce(0) { $0 + $1.totalCount }
                        Text("Total: \(total) donations")
                            .font(.caption)
                            .padding(.top, 4)
                    }
                }
                .frame(height: 300)
            }
        }
        .padding()
        .hierarchicalBackground(level: .tertiary, cornerRadius: 12)
        .shadow(radius: 2)
    }
}
