//
//  RecentDonationsCard.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 11/11/25.
//

import SwiftUI
import SwiftData

/// Model for recent donation items
struct DonationItem: Identifiable {
    let id = UUID()
    let title: String
    let time: String
    let color: Color
}

/// Card showing recent donations
struct RecentDonationsCard: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var categoryManager: CategoryManager
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.acLeafGreen)
                    .font(.headline)
                Text("Recent Donations")
                    .font(.headline)
                    .foregroundColor(.black)
            }

            if let recentDonations = getRecentDonations(), !recentDonations.isEmpty {
                ForEach(0 ..< recentDonations.prefix(4).count, id: \.self) { index in
                    let donation = recentDonations[index]
                    VStack(spacing: 0) {
                        HStack {
                            Text("◆")
                                .foregroundColor(donation.color)

                            Text(donation.title)
                                .font(.subheadline)
                                .foregroundColor(.black)

                            Spacer()

                            Text(donation.time)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)

                        if index < recentDonations.prefix(4).count - 1 {
                            Divider()
                        }
                    }
                }

                HStack {
                    Spacer()

                    Button(action: {
                        // Switch to analytics view
                        categoryManager.showAnalytics()
                    }) {
                        HStack {
                            Text("See Activity")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.acLeafGreen)
                        .cornerRadius(15)
                    }

                    Spacer()
                }
                .padding(.top, 8)
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.title)
                        .foregroundColor(.gray.opacity(0.5))

                    Text("No recent donations")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
        .padding()
        .background(Color.acBellYellow.opacity(0.2))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }

    // Real implementation to get recent donations
    private func getRecentDonations() -> [DonationItem]? {
        // Get all donated items with timestamp
        var donatedItems: [(name: String, date: Date, color: Color)] = []

        // Add fossils
        let fossils: [Fossil] = {
            do {
                return try dataManager.getFossilsForCurrentTown()
            } catch {
                print("Error fetching fossils for current town: \(error)")
                return []
            }
        }()
        for fossil in fossils.filter({ $0.isDonated && $0.donationDate != nil }) {
            if let date = fossil.donationDate {
                let name = fossil.part != nil ? "\(fossil.name) \(fossil.part!)" : fossil.name
                donatedItems.append((name: name, date: date, color: .acMuseumBrown))
            }
        }

        // Add bugs
        let bugs: [Bug] = {
            do {
                return try dataManager.getBugsForCurrentTown()
            } catch {
                print("Error fetching bugs for current town: \(error)")
                return []
            }
        }()
        for bug in bugs.filter({ $0.isDonated && $0.donationDate != nil }) {
            if let date = bug.donationDate {
                donatedItems.append((name: bug.name, date: date, color: .green))
            }
        }

        // Add fish
        let fish: [Fish] = {
            do {
                return try dataManager.getFishForCurrentTown()
            } catch {
                print("Error fetching fish for current town: \(error)")
                return []
            }
        }()
        for fish in fish.filter({ $0.isDonated && $0.donationDate != nil }) {
            if let date = fish.donationDate {
                donatedItems.append((name: fish.name, date: date, color: .acOceanBlue))
            }
        }

        // Add art
        let art: [Art] = {
            do {
                return try dataManager.getArtForCurrentTown()
            } catch {
                print("Error fetching art for current town: \(error)")
                return []
            }
        }()
        for art in art.filter({ $0.isDonated && $0.donationDate != nil }) {
            if let date = art.donationDate {
                donatedItems.append((name: art.name, date: date, color: .acBlathersPurple))
            }
        }

        // Sort by date (most recent first)
        donatedItems.sort { $0.date > $1.date }

        // Convert to DonationItem objects with relative time
        return donatedItems.prefix(4).map { item in
            DonationItem(
                title: item.name,
                time: relativeTimeString(from: item.date),
                color: item.color
            )
        }
    }

    // Helper to format relative time
    private func relativeTimeString(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day, .hour, .minute], from: date, to: now)

        if let day = components.day, day > 0 {
            return day == 1 ? "Yesterday" : "\(day) days ago"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) hour\(hour == 1 ? "" : "s") ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) minute\(minute == 1 ? "" : "s") ago"
        } else {
            return "Just now"
        }
    }
}
