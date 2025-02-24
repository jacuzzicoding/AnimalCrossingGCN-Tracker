//
//  DonationHistoryView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created by Brock Jenkinson on 2/24/25.
//

import SwiftUI
import SwiftData
import Charts

struct DonationHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: DonationTrackingViewModel
    @State private var selectedTab = 0
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: DonationTrackingViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab selector
                Picker("View", selection: $selectedTab) {
                    Text("Overview").tag(0)
                    Text("History").tag(1)
                    Text("Calendar").tag(2)
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Filters section
                filtersSection
                
                // Main content based on selected tab
                TabView(selection: $selectedTab) {
                    overviewTab.tag(0)
                    historyTab.tag(1)
                    calendarTab.tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("Donation History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.resetFilters()
                        }
                    }) {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                    }
                }
            }
            .task {
                await viewModel.loadDonationData()
            }
        }
    }
    
    // MARK: - Filter Section
    
    private var filtersSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Filters")
                    .font(.headline)
                Spacer()
                Button(action: {
                    Task {
                        await viewModel.applyFilters()
                    }
                }) {
                    Text("Apply")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    // Date range filter
                    Menu {
                        ForEach(DateRange.allCases) { range in
                            Button(action: {
                                viewModel.selectedDateRange = range
                            }) {
                                Label(range.rawValue, systemImage: range == viewModel.selectedDateRange ? "checkmark" : "")
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "calendar")
                            Text(viewModel.selectedDateRange.rawValue)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    // Custom date range (if selected)
                    if viewModel.selectedDateRange == .custom {
                        DatePicker("From", selection: $viewModel.startDate, displayedComponents: .date)
                            .labelsHidden()
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                        
                        DatePicker("To", selection: $viewModel.endDate, displayedComponents: .date)
                            .labelsHidden()
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    // Game selection
                    Menu {
                        Button(action: {
                            viewModel.selectedGame = nil
                        }) {
                            Label("All Games", systemImage: viewModel.selectedGame == nil ? "checkmark" : "")
                        }
                        
                        ForEach(ACGame.allCases, id: \.self) { game in
                            Button(action: {
                                viewModel.selectedGame = game
                            }) {
                                Label(game.rawValue, systemImage: viewModel.selectedGame == game ? "checkmark" : "")
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "gamecontroller")
                            Text(viewModel.selectedGame?.rawValue ?? "All Games")
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    // Category filters
                    Menu {
                        ForEach(ItemCategory.allCases) { category in
                            Button(action: {
                                if viewModel.selectedCategories.contains(category) {
                                    viewModel.selectedCategories.remove(category)
                                } else {
                                    viewModel.selectedCategories.insert(category)
                                }
                            }) {
                                Label(category.rawValue, systemImage: viewModel.selectedCategories.contains(category) ? "checkmark.square.fill" : "square")
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "folder")
                            Text("Categories (\(viewModel.selectedCategories.count))")
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .background(Color.secondary.opacity(0.05))
    }
    
    // MARK: - Overview Tab
    
    private var overviewTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Donation statistics
                HStack(spacing: 16) {
                    statsCard(
                        title: "Total Donations",
                        value: "\(viewModel.totalDonations)",
                        icon: "gift.fill",
                        color: .blue
                    )
                    
                    if let lastMonth = viewModel.monthlyDonationCounts.last {
                        statsCard(
                            title: "Last Month",
                            value: "\(lastMonth.count)",
                            icon: "calendar",
                            color: .green
                        )
                    } else {
                        statsCard(
                            title: "Last Month",
                            value: "0",
                            icon: "calendar",
                            color: .green
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Donation trend chart
                VStack(alignment: .leading, spacing: 8) {
                    Text("Donation Trends")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if viewModel.monthlyDonationCounts.isEmpty {
                        Text("No donation data available for the selected filters")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(Color.secondary.opacity(0.05))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    } else {
                        Chart {
                            ForEach(viewModel.monthlyDonationCounts) { monthData in
                                BarMark(
                                    x: .value("Month", monthData.monthString),
                                    y: .value("Count", monthData.count)
                                )
                                .foregroundStyle(Color.blue.gradient)
                            }
                        }
                        .frame(height: 200)
                        .padding()
                        .background(Color.secondary.opacity(0.05))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                
                // Category breakdown
                VStack(alignment: .leading, spacing: 8) {
                    Text("Category Breakdown")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if viewModel.monthlyDonationCounts.isEmpty {
                        Text("No donation data available for the selected filters")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(Color.secondary.opacity(0.05))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    } else if let lastMonth = viewModel.monthlyDonationCounts.last {
                        Chart {
                            BarMark(
                                x: .value("Category", "Fossils"),
                                y: .value("Count", lastMonth.fossilCount)
                            )
                            .foregroundStyle(ItemCategory.fossils.color.gradient)
                            
                            BarMark(
                                x: .value("Category", "Bugs"),
                                y: .value("Count", lastMonth.bugCount)
                            )
                            .foregroundStyle(ItemCategory.bugs.color.gradient)
                            
                            BarMark(
                                x: .value("Category", "Fish"),
                                y: .value("Count", lastMonth.fishCount)
                            )
                            .foregroundStyle(ItemCategory.fish.color.gradient)
                            
                            BarMark(
                                x: .value("Category", "Art"),
                                y: .value("Count", lastMonth.artCount)
                            )
                            .foregroundStyle(ItemCategory.art.color.gradient)
                            
                            BarMark(
                                x: .value("Category", "Sea Creatures"),
                                y: .value("Count", lastMonth.seaCreatureCount)
                            )
                            .foregroundStyle(ItemCategory.seaCreatures.color.gradient)
                        }
                        .frame(height: 200)
                        .padding()
                        .background(Color.secondary.opacity(0.05))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                
                // Recent donations
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recent Donations")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if viewModel.recentDonations.isEmpty {
                        Text("No recent donations found")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .background(Color.secondary.opacity(0.05))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    } else {
                        VStack(spacing: 0) {
                            ForEach(viewModel.recentDonations) { item in
                                HStack {
                                    Image(systemName: item.category.iconName)
                                        .foregroundColor(item.category.color)
                                        .frame(width: 30)
                                    
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .fontWeight(.medium)
                                        
                                        if let date = item.donationDate {
                                            Text(date.formatted(date: .abbreviated, time: .omitted))
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Text(item.category.rawValue)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(item.category.color.opacity(0.1))
                                        .foregroundColor(item.category.color)
                                        .cornerRadius(4)
                                }
                                .padding()
                                .background(Color.secondary.opacity(0.05))
                                
                                if item.id != viewModel.recentDonations.last?.id {
                                    Divider()
                                        .padding(.leading, 46)
                                }
                            }
                        }
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.bottom)
        }
    }
    
    // MARK: - History Tab
    
    private var historyTab: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if viewModel.recentDonations.isEmpty {
                    Text("No donations found for the selected filters")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .padding()
                } else {
                    // Group by month
                    let groupedDonations = Dictionary(grouping: viewModel.recentDonations) { item -> String in
                        guard let date = item.donationDate else { return "Unknown" }
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MMMM yyyy"
                        return formatter.string(from: date)
                    }
                    
                    ForEach(groupedDonations.keys.sorted(by: { key1, key2 in
                        // Sort months in reverse chronological order
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MMMM yyyy"
                        guard let date1 = formatter.date(from: key1),
                              let date2 = formatter.date(from: key2) else {
                            return key1 > key2 // Fallback to string comparison
                        }
                        return date1 > date2
                    }), id: \.self) { monthKey in
                        if let monthItems = groupedDonations[monthKey] {
                            Section(header: sectionHeader(title: monthKey, count: monthItems.count)) {
                                ForEach(monthItems) { item in
                                    HStack {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(item.category.color)
                                            .frame(width: 4, height: 36)
                                        
                                        Image(systemName: item.category.iconName)
                                            .foregroundColor(item.category.color)
                                            .frame(width: 30)
                                        
                                        VStack(alignment: .leading) {
                                            Text(item.name)
                                                .fontWeight(.medium)
                                            
                                            if let date = item.donationDate {
                                                Text(date.formatted(date: .complete, time: .omitted))
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        Text(item.category.rawValue)
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(item.category.color.opacity(0.1))
                                            .foregroundColor(item.category.color)
                                            .cornerRadius(4)
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal)
                                    .background(Color.white.opacity(0.001)) // For tap gesture
                                    
                                    if item.id != monthItems.last?.id {
                                        Divider()
                                            .padding(.leading, 54)
                                    }
                                }
                            }
                            .padding(.bottom, 16)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    // MARK: - Calendar Tab
    
    private var calendarTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Calendar visualization will be implemented in a future update")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .multilineTextAlignment(.center)
                    .padding()
                
                // Placeholder for future calendar implementation
                Image(systemName: "calendar")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }
    
    // MARK: - Helper Views
    
    private func statsCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func sectionHeader(title: String, count: Int) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            
            Text("(\(count))")
                .foregroundColor(.secondary)
                .font(.subheadline)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.secondary.opacity(0.1))
    }
}

// MARK: - Previews
struct DonationHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        DonationHistoryView(modelContext: try! ModelContainer(for: Fossil.self, Bug.self, Fish.self, Art.self).mainContext)
    }
}
