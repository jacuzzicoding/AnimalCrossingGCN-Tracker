//
//  HomeView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 3/1/25.
//  Updated on 2/27/25.
//
//  This file implements the home screen for the Animal Crossing GCN Tracker app.
//  It provides an overview of the user's museum collection status and quick access
//  to key functionality. The interface adapts for both light and dark mode.

import SwiftUI
import SwiftData

#if canImport(UIKit)
import UIKit
#endif

/// Main home screen view for the Animal Crossing GCN Tracker app
struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var categoryManager: CategoryManager
    @StateObject private var viewModel: HomeViewModel
    @State private var isEditingTown: Bool = false
    
    init() {
        // Create the view model with data manager - will be injected later
        _viewModel = StateObject(wrappedValue: HomeViewModel(dataManager: DataManager(modelContext: ModelContext(ModelContainer(for: Town.self).mainContext))))
    }
    
    var body: some View {
        ZStack {
            // Main content
            ScrollView {
            VStack(spacing: 16) {
                // Header with town info
                HomeHeaderView(isEditingTown: $isEditingTown)
                    .padding(.bottom, 4)
                
                // Collection status card
                CollectionStatusCard(viewModel: viewModel)
                
                // Category grid
                CategoryGridView(viewModel: viewModel)
                    .padding(.vertical, 8)
                
                // Seasonal highlights
                SeasonalHighlightsCard(viewModel: viewModel)
                
                // Recent donations
                RecentDonationsCard(viewModel: viewModel)
                
                // Spacer for bottom tab bar
                Spacer().frame(height: 20)
            }
            .padding()
            .multilineTextAlignment(.center)
            
            // Loading overlay
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .padding()
                    
                    Text("Loading...")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.1))
            }
            
            // Error message
            if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    
                    Text(errorMessage)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("Retry") {
                        viewModel.refreshData()
                    }
                    .padding()
                    .background(Color.acLeafGreen)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding()
            }
        }
        .onAppear {
            viewModel.loadInitialData()
        }
        .onChange(of: dataManager) { _, _ in
            // When dataManager changes, update viewModel
            viewModel.loadInitialData()
        }
        .background(Color(hex: "F9F5E9")) // Parchment background
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $isEditingTown) {
            if let town = dataManager.currentTown {
                EditTownView(isPresented: $isEditingTown, townName: .constant(town.name))
                    .environmentObject(dataManager)
            }
        }
    }
}

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

/// Card showing overall collection status
struct CollectionStatusCard: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "museum.fill")
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
                        .frame(width: min(CGFloat(viewModel.collectionStatus.completionPercentage) * geometry.size.width, geometry.size.width), height: 20)
                        .foregroundColor(Color.acLeafGreen)
                        .cornerRadius(10)
                        .animation(.easeInOut, value: viewModel.collectionStatus.completionPercentage)
                    
                    HStack {
                        Spacer()
                        Text("\(Int(viewModel.collectionStatus.completionPercentage * 100))%")
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
                Text("\(viewModel.collectionStatus.totalCollected) of \(viewModel.collectionStatus.totalAvailable) Items Donated")
                    .font(.subheadline)
                    .foregroundColor(.black)
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Museum Collection Status: \(Int(viewModel.collectionStatus.completionPercentage * 100))% complete")
    }
}

/// Grid of category cards with completion status
struct CategoryGridView: View {
	@EnvironmentObject var dataManager: DataManager
	@EnvironmentObject var categoryManager: CategoryManager
	@ObservedObject var viewModel: HomeViewModel
	
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
				ForEach(viewModel.categoryProgress) { category in
				    CategoryCard(
				    categoryData: category,
				    viewModel: viewModel
				)
				}
			}
		}
	}
	
	/// Individual category card component
	struct CategoryCard: View {
		@EnvironmentObject var categoryManager: CategoryManager
		@ObservedObject var viewModel: HomeViewModel
		
		let categoryData: CategoryProgressData
		
		var body: some View {
			Button(action: {
				// Handle category selection and navigation through ViewModel
				viewModel.navigateToCategory(categoryData.category, categoryManager: categoryManager)
			}) {
				VStack(spacing: 12) {
					HStack {
						Image(systemName: categoryData.category.symbolName)
							.font(.system(size: 18))
							.foregroundColor(.white)
						
						Text(categoryData.name)
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
							Text("\(categoryData.progressPercentage)%")
								.font(.headline)
								.fontWeight(.bold)
								.foregroundColor(.white)
							
							Text("\(categoryData.collected)/\(categoryData.total)")
								.font(.caption)
								.foregroundColor(.white.opacity(0.9))
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
				.background(categoryData.color)
				.cornerRadius(10)
				.shadow(color: categoryData.color.opacity(0.3), radius: 4, x: 0, y: 2)
				.accessibilityElement(children: .combine)
				.accessibilityLabel("\(categoryData.name): \(categoryData.progressPercentage)% complete")
			}
		}
	}
}

/// Card showing seasonal highlights
struct SeasonalHighlightsCard: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "leaf.fill")
                    .foregroundColor(.acLeafGreen)
                    .font(.headline)
                Text("Seasonal Highlights")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    if !viewModel.seasonalHighlights.isEmpty {
                        ForEach(viewModel.seasonalHighlights, id: \.id) { item in
                            SeasonalItemView(
                                title: item.name,
                                description: item.description,
                                color: item.isLeaving ? .acPumpkinOrange : .acLeafGreen
                            )
                        }
                    } else {
                        Text("No seasonal items available")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
            }
        }
        .padding()
        .background(Color.acBellYellow.opacity(0.2))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
    
    // No longer need these methods, handled by the ViewModel now
}

// Seasonal item model
struct SeasonalItem: Identifiable {
    let id: String
    let name: String
    let description: String
    let isLeaving: Bool
}

/// Individual seasonal item component
struct SeasonalItemView: View {
    let title: String
    let description: String
    let color: Color
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text(description)
                .font(.caption)
                .foregroundColor(color)
        }
        .padding()
        .frame(width: 140, height: 80)
        .background(Color.white.opacity(0.8))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(description)")
    }
}

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
    @ObservedObject var viewModel: HomeViewModel
    
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
            
            if !viewModel.recentDonations.isEmpty {
                ForEach(0 ..< viewModel.recentDonations.prefix(4).count, id: \.self) { index in
                    let donation = viewModel.recentDonations[index]
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
                        
                        if index < viewModel.recentDonations.prefix(4).count - 1 {
                            Divider()
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // Navigate to analytics view through ViewModel
                        viewModel.navigateToAnalytics(categoryManager: categoryManager)
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
    
    // No longer need these methods, handled by the ViewModel now
}

// Helper extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview Providers
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Town.self, Fossil.self, Bug.self, Fish.self, Art.self, configurations: config)
        
        let context = container.mainContext
        let town = Town(name: "Nookville", playerName: "Tom Nook", game: .ACGCN)
        context.insert(town)
        
        let dataManager = DataManager(modelContext: context)
        let categoryManager = CategoryManager()
        
        return HomeView()
            .environmentObject(dataManager)
            .environmentObject(categoryManager)
            .environmentObject(HomeViewModel(dataManager: dataManager))
    }
}
