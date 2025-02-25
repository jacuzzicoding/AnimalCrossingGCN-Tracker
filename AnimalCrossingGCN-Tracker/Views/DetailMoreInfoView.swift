//
//  DetailMoreInfoView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 12/18/24.
//

import SwiftUI

struct DetailMoreInfoView<Item: CollectibleItem>: View {
	let item: Item
	@State private var isExpanded = false
	
	var body: some View {
		VStack(spacing: 8) {
			Button(action: {
				withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
					isExpanded.toggle()
				}
			}) {
				HStack {
					Text("More Info")
						.foregroundColor(.primary)
					Spacer()
					Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
						.foregroundColor(.secondary)
				}
				.padding()
				.background(Color.gray.opacity(0.1))
				.cornerRadius(10)
			}
			
			if isExpanded {
				/*Debug info
				Text("Debug: isDonated = \(item.isDonated.description)")
				Text("Debug: donationDate = \(item.donationDate?.description ?? "nil")")
				*/
				VStack(alignment: .leading, spacing: 12) {
					if item.isDonated, let donationDate = item.donationDate {
						HStack(spacing: 12) {
							Image(systemName: "calendar")
								.foregroundColor(.secondary)
							
							VStack(alignment: .leading) {
								Text("Donated")
									.font(.caption)
									.foregroundColor(.secondary)
								Text(donationDate.formatted(date: .long, time: .omitted))
									.foregroundColor(.primary)
							}
						}
					}
					
					// Game Version Info
					HStack(spacing: 12) {
						Image(systemName: "gamecontroller")
							.foregroundColor(.secondary)
						
						VStack(alignment: .leading) {
							Text("Available in")
								.font(.caption)
								.foregroundColor(.secondary)
							
							HStack {
								ForEach(item.games, id: \.self) { game in
									Text(game.shortName)
										.font(.caption)
										.padding(.horizontal, 6)
										.padding(.vertical, 2)
										.background(Color.blue.opacity(0.1))
										.cornerRadius(4)
								}
							}
						}
					}
					
					// Future info sections can be added here
				}
				.padding()
				.background(Color.gray.opacity(0.1))
				.cornerRadius(10)
				.transition(.move(edge: .top).combined(with: .opacity))
			}
		}
		.padding(.horizontal)
	}
}

/* Preview provider for testing
struct DetailMoreInfoView_Previews: PreviewProvider {
	static var previews: some View {
		DetailMoreInfoView(item: previewArt) // You'll need to create a preview item
			.preferredColorScheme(.dark)
	}
}
*/
