//
//  CategoryGridView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 11/11/25.
//

import SwiftUI
import SwiftData

/// Grid of category cards with completion status
struct CategoryGridView: View {
	@EnvironmentObject var dataManager: DataManager
	@EnvironmentObject var categoryManager: CategoryManager

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Image(systemName: "square.grid.2x2.fill")
					.foregroundColor(.acLeafGreen)
					.font(.headline)
				Text("Museum Categories")
					.font(.headline)
					.foregroundColor(.black)
			}
			.padding(.bottom, 6)

			LazyVGrid(columns: [
				GridItem(.flexible()),
				GridItem(.flexible())
			], spacing: 16) {
				// Fossils card
				CategoryCard(
					title: "FOSSILS",
					icon: "leaf.arrow.circlepath",
					progress: dataManager.getCurrentTownFossilProgress(),
					color: .acMuseumBrown,
					emoji: "🦴",
					category: .fossils
				)

				// Bugs card
				CategoryCard(
					title: "BUGS",
					icon: "ant.fill",
					progress: dataManager.getCurrentTownBugProgress(),
					color: .green,
					emoji: "🐛",
					category: .bugs
				)

				// Fish card
				CategoryCard(
					title: "FISH",
					icon: "fish.fill",
					progress: dataManager.getCurrentTownFishProgress(),
					color: .acOceanBlue,
					emoji: "🐟",
					category: .fish
				)

				// Art card
				CategoryCard(
					title: "ART",
					icon: "paintpalette.fill",
					progress: dataManager.getCurrentTownArtProgress(),
					color: .acBlathersPurple,
					emoji: "🎨",
					category: .art
				)
			}
		}
	}

	/// Individual category card component
	struct CategoryCard: View {
		@EnvironmentObject var categoryManager: CategoryManager
		@EnvironmentObject var dataManager: DataManager

		let title: String
		let icon: String
		let progress: Double
		let color: Color
		let emoji: String
		let category: Category

		// Computed property for donation info
		private var donationInfo: String? {
            do {
                guard let completion = try dataManager.getCategoryCompletionData() else { return nil }
                let donated: Int
                let total: Int

                switch category {
                case .fossils:
                    donated = completion.fossilDonated
                    total = completion.fossilCount
                case .bugs:
                    donated = completion.bugDonated
                    total = completion.bugCount
                case .fish:
                    donated = completion.fishDonated
                    total = completion.fishCount
                case .art:
                    donated = completion.artDonated
                    total = completion.artCount
                }

                return "\(donated)/\(total)"
            } catch {
                print("Error fetching category completion data in CategoryCard: \(error)")
                return nil
            }
        }

		var body: some View {
			Button(action: {
				// Handle category selection and navigation
				categoryManager.selectedItem = nil
				categoryManager.selectedCategory = category
				categoryManager.showingAnalytics = false
			}) {
				VStack(spacing: 12) {
					HStack {
						Image(systemName: category.symbolName)
							.font(.system(size: 18))
							.foregroundColor(.white)

						Text(title)
							.font(.headline)
							.foregroundColor(.white)

						Spacer()
					}

					Spacer()

					ZStack {
						Circle()
							.fill(Color.white.opacity(0.2))
							.frame(width: 60, height: 60)

						VStack(spacing: 4) {
							Text("\(Int(progress * 100))%")
								.font(.headline)
								.fontWeight(.bold)
								.foregroundColor(.white)

							if let info = donationInfo {
								Text(info)
									.font(.caption)
									.foregroundColor(.white.opacity(0.9))
							}
						}
					}

					Spacer()

					Spacer()

					HStack {
						Spacer()

						HStack {
							Text("View All")
								.font(.caption)
								.fontWeight(.semibold)
								.foregroundColor(.white)

							Image(systemName: "chevron.right")
								.font(.caption)
								.foregroundColor(.white)
						}
						.padding(.horizontal, 12)
						.padding(.vertical, 6)
						.background(Color.white.opacity(0.3))
						.cornerRadius(15)

						Spacer()
					}
				}
				.padding()
				.frame(height: 130)
				.background(color)
				.cornerRadius(10)
				.shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
				.accessibilityElement(children: .combine)
				.accessibilityLabel("\(title): \(Int(progress * 100))% complete")
			}
		}
	}
}
