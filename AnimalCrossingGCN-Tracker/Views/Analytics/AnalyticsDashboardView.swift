//
//  AnalyticsDashboardView.swift
//  AnimalCrossingGCN-Tracker
//
//  Created on 2/26/25.
//

import SwiftUI
import Charts
import SwiftData // Add this import for UIColor

#if canImport(UIKit)
import UIKit
#endif

// Define Animal Crossing color extension
extension Color {
    static let acLeafGreen = Color(red: 107/255, green: 211/255, blue: 139/255) // #6BD38B
    static let acMuseumBrown = Color(red: 184/255, green: 125/255, blue: 75/255) // #B87D4B
    static let acOceanBlue = Color(red: 122/255, green: 205/255, blue: 244/255) // #7ACDF4
    static let acBellYellow = Color(red: 250/255, green: 216/255, blue: 123/255) // #FAD87B
    static let acBlathersPurple = Color(red: 161/255, green: 122/255, blue: 196/255) // #A17AC4
    static let acPumpkinOrange = Color(red: 237/255, green: 138/255, blue: 51/255) // #ED8A33
    static let acWinterBlue = Color(red: 138/255, green: 189/255, blue: 222/255) // #8ABDDE
}

// Define BackgroundLevel enum outside the extension
enum BackgroundLevel {
    case secondary
    case tertiary
}

// Extension to handle hierarchical backgrounds across iOS versions and platforms
extension View {
    @ViewBuilder
    func hierarchicalBackground(level: BackgroundLevel = .secondary, cornerRadius: CGFloat = 10) -> some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            switch level {
            case .secondary:
                self.background(.background.secondary)
                    .cornerRadius(cornerRadius)
            case .tertiary:
                self.background(.background.tertiary)
                    .cornerRadius(cornerRadius)
            }
        } else {
            #if os(iOS)
            switch level {
            case .secondary:
                self.background(Color(uiColor: UIColor.secondarySystemBackground))
                    .cornerRadius(cornerRadius)
            case .tertiary:
                self.background(Color(uiColor: UIColor.tertiarySystemBackground))
                    .cornerRadius(cornerRadius)
            }
            #else
            // For macOS or other platforms
            switch level {
            case .secondary:
                self.background(Color.secondary.opacity(0.2))
                    .cornerRadius(cornerRadius)
            case .tertiary:
                self.background(Color.secondary.opacity(0.1))
                    .cornerRadius(cornerRadius)
            }
            #endif
        }
    }
}

#if DEBUG
// Debug view to show analytics data metrics
struct AnalyticsDebugView: View {
    let timelineData: [MonthlyDonationActivity]
    let completionData: CategoryCompletionData?
    let fossilsWithDates: Int
    let bugsWithDates: Int
    let fishWithDates: Int
    let artWithDates: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Debug Information")
                .font(.headline)
            
            Text("Timeline Data: \(timelineData.count) months")
                .font(.caption)
            
            Text("Items with donation dates:")
                .font(.caption)
            Text("- Fossils: \(fossilsWithDates)")
                .font(.caption)
            Text("- Bugs: \(bugsWithDates)")
                .font(.caption)
            Text("- Fish: \(fishWithDates)")
                .font(.caption)
            Text("- Art: \(artWithDates)")
                .font(.caption)
            
            if let completion = completionData {
                Text("Completion Data:")
                    .font(.caption)
                Text("- Fossils: \(completion.fossilDonated)/\(completion.fossilCount) (\(Int(completion.fossilProgress * 100))%)")
                    .font(.caption)
                Text("- Bugs: \(completion.bugDonated)/\(completion.bugCount) (\(Int(completion.bugProgress * 100))%)")
                    .font(.caption)
                Text("- Fish: \(completion.fishDonated)/\(completion.fishCount) (\(Int(completion.fishProgress * 100))%)")
                    .font(.caption)
                Text("- Art: \(completion.artDonated)/\(completion.artCount) (\(Int(completion.artProgress * 100))%)")
                    .font(.caption)
                Text("- Total: \(completion.totalDonated)/\(completion.totalCount) (\(Int(completion.totalProgress * 100))%)")
                    .font(.caption)
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
#endif

// Main Dashboard View
struct AnalyticsDashboardView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @State private var timelineData: [MonthlyDonationActivity] = []
    @State private var completionData: CategoryCompletionData?
    @State private var seasonalData: SeasonalData?
    
    // For debug information
    @State private var fossilsWithDates: Int = 0
    @State private var bugsWithDates: Int = 0
    @State private var fishWithDates: Int = 0
    @State private var artWithDates: Int = 0
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        VStack(spacing: 16) {
            if let town = dataManager.currentTownDTO {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Analytics for \(town.name)")
                            .font(.title)
                        Spacer()
                        Text("\(Int(town.totalProgress * 100))% Complete")
                            .bold()
                    }
                    .padding(.bottom)
                    
                    Picker("View", selection: $selectedTab) {
                        Text("Dashboard").tag(0)
                        Text("Timeline").tag(1)
                        Text("Categories").tag(2)
                        Text("Seasonal").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom)
                    
                    switch selectedTab {
                    case 0:
                        // Dashboard overview
                        ScrollView {
                            VStack(spacing: 16) {
                                // Overall progress card
                                if let completion = completionData {
                                    overallProgressCard(completion: completion)
                                }
                                
                                // Recent activity (simplified timeline)
                                if !timelineData.isEmpty {
                                    recentActivityCard(data: Array(timelineData.suffix(3)))
                                }
                                
                                // Current season
                                if let seasonal = seasonalData, let current = seasonal.currentSeasonCompletion() {
                                    currentSeasonCard(season: current)
                                }
                                
                                // Category breakdown (mini version)
                                if let completion = completionData {
                                    categoryBreakdownCard(completion: completion)
                                }
                                
                                #if DEBUG
                                // Debug information
                                AnalyticsDebugView(
                                    timelineData: timelineData,
                                    completionData: completionData,
                                    fossilsWithDates: fossilsWithDates,
                                    bugsWithDates: bugsWithDates,
                                    fishWithDates: fishWithDates,
                                    artWithDates: artWithDates
                                )
                                .padding(.top, 16)
                                #endif
                            }
                        }
                        
                    case 1:
                        // Timeline view
                        ScrollView {
                            DonationTimelineView(timelineData: timelineData)
                        }
                        
                    case 2:
                        // Category view
                        ScrollView {
                            if let completion = completionData {
                                CategoryCompletionChartView(completionData: completion)
                            }
                        }
                        
                    case 3:
                        // Seasonal view
                        ScrollView {
                            if let seasonal = seasonalData {
                                SeasonalAnalysisView(seasonalData: seasonal)
                            }
                        }
                        
                    default:
                        EmptyView()
                    }
                    
                }
                .padding()
            } else {
                Text("Please select a town to view analytics")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            loadData()
        }
        .onChange(of: dataManager.currentTown) { _, _ in
            loadData()
        }
        #if DEBUG
        .toolbar {
            ToolbarItem {
                Button("Generate Test Data") {
                    dataManager.generateTestDonationData()
                    loadData() // Reload analytics data after generating test data
                }
                .buttonStyle(.bordered)
                .tint(.blue)
            }
        }
        #endif
    }
    
    private func loadData() {
        guard let _ = dataManager.currentTown else { return }
        
        // Ensure the cache is invalidated to get fresh data
        dataManager.analyticsService.invalidateCache()
        
        // Load actual data from the DataManager
        timelineData = dataManager.getDonationActivityByMonth()
        completionData = dataManager.getCategoryCompletionData()
        seasonalData = dataManager.getSeasonalData()
        
        // For debug information, count items with donation dates
        let fossils = dataManager.getFossilsForCurrentTown()
        let bugs = dataManager.getBugsForCurrentTown()
        let fish = dataManager.getFishForCurrentTown()
        let art = dataManager.getArtForCurrentTown()
        
        fossilsWithDates = fossils.filter { $0.isDonated && $0.donationDate != nil }.count
        bugsWithDates = bugs.filter { $0.isDonated && $0.donationDate != nil }.count
        fishWithDates = fish.filter { $0.isDonated && $0.donationDate != nil }.count
        artWithDates = art.filter { $0.isDonated && $0.donationDate != nil }.count
        
        print("Analytics data loaded: \(timelineData.count) months, \(fossilsWithDates + bugsWithDates + fishWithDates + artWithDates) items with dates")
    }
    }
    
    // MARK: - Dashboard card views
    private func overallProgressCard(completion: CategoryCompletionData) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "museum.fill")
                    .foregroundColor(.acLeafGreen)
                Text("Museum Progress")
                    .font(.headline)
            }
            
            HStack {
                Text("\(completion.totalDonated) of \(completion.totalCount) items donated")
                Spacer()
                Text("\(Int(completion.totalProgress * 100))%")
                    .bold()
            }
            
            ProgressView(value: completion.totalProgress)
                .tint(.acLeafGreen)
                .animation(.spring(duration: 0.6), value: completion.totalProgress)
        }
        .padding()
        .hierarchicalBackground()
        .animation(.easeIn, value: completion.totalProgress)
    }
    
    private func recentActivityCard(data: [MonthlyDonationActivity]) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .foregroundColor(.acBellYellow)
                Text("Recent Activity")
                    .font(.headline)
            }
            
            if data.isEmpty {
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.title)
                            .foregroundColor(.gray)
                            .padding(.bottom, 4)
                        Text("No donation data yet")
                            .foregroundColor(.secondary)
                        Text("Donate items to see your activity")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.vertical)
            } else {
                ForEach(data) { activity in
                    HStack {
                        Text(activity.formattedMonth)
                        Spacer()
                        Text("\(activity.totalCount) donations")
                            .bold()
                    }
                    .padding(.vertical, 4)
                    
                    if data.last?.id != activity.id {
                        Divider()
                    }
                }
            }
        }
        .padding()
        .hierarchicalBackground()
    }
    
    private func currentSeasonCard(season: SeasonalCompletion) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "leaf.fill")
                    .foregroundColor(.acLeafGreen)
                Text("Currently Available")
                    .font(.headline)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "ant.fill")
                            .foregroundColor(.green)
                        Text("Bugs")
                            .font(.subheadline)
                    }
                    Text("\(season.bugDonated) of \(season.bugCount)")
                        .foregroundColor(.secondary)
                    ProgressView(value: season.bugProgress)
                        .tint(.green)
                        .animation(.spring(duration: 0.6), value: season.bugProgress)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "fish.fill")
                            .foregroundColor(.blue)
                        Text("Fish")
                            .font(.subheadline)
                    }
                    Text("\(season.fishDonated) of \(season.fishCount)")
                        .foregroundColor(.secondary)
                    ProgressView(value: season.fishProgress)
                        .tint(.blue)
                        .animation(.spring(duration: 0.6), value: season.fishProgress)
                }
            }
            
            HStack {
                Spacer()
                Text("This month: \(Int(season.totalProgress * 100))% complete")
                    .font(.caption)
                    .padding(.top, 4)
                    .foregroundColor(seasonColor(for: season.season))
                    .bold()
            }
        }
        .padding()
        .hierarchicalBackground()
        .animation(.easeIn, value: season.totalProgress)
    }
    
    private func seasonColor(for month: String) -> Color {
        let springMonths = ["Mar", "Apr", "May"]
        let summerMonths = ["Jun", "Jul", "Aug"]
        let fallMonths = ["Sep", "Oct", "Nov"]
        // Winter is the default
        
        if springMonths.contains(month) {
            return .acLeafGreen // Spring green
        } else if summerMonths.contains(month) {
            return .acBellYellow // Summer yellow
        } else if fallMonths.contains(month) {
            return .acPumpkinOrange // Fall orange
        } else {
            return .acWinterBlue // Winter blue
        }
    }
    
    private func categoryBreakdownCard(completion: CategoryCompletionData) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "square.grid.2x2.fill")
                    .foregroundColor(.acBlathersPurple)
                Text("Categories")
                    .font(.headline)
            }
            
            HStack {
                CategoryMiniProgress(label: "Fossils", progress: completion.fossilProgress, color: .acMuseumBrown, icon: "leaf.arrow.circlepath")
                CategoryMiniProgress(label: "Bugs", progress: completion.bugProgress, color: .green, icon: "ant.fill")
                CategoryMiniProgress(label: "Fish", progress: completion.fishProgress, color: .acOceanBlue, icon: "fish.fill")
                CategoryMiniProgress(label: "Art", progress: completion.artProgress, color: .acBlathersPurple, icon: "paintpalette.fill")
            }
        }
        .padding()
        .hierarchicalBackground()
        .animation(.easeIn, value: completion.totalProgress)
    }
}

// Helper view for mini progress indicators
struct CategoryMiniProgress: View {
    let label: String
    let progress: Double
    let color: Color
    let icon: String
    
    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
            
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 5)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: CGFloat(progress))
                    .stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
                
                VStack {
                    Image(systemName: icon)
                        .font(.caption)
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 9))
                        .bold()
                }
            }
        }
    }
}

// MARK: - Chart Views

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

// Helper view for category progress
struct CategoryProgressView: View {
    let label: String
    let progress: Double
    let donated: Int
    let total: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .bold()
            }
            
            ProgressView(value: progress)
                .tint(color)
            
            Text("\(donated) of \(total) donated")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

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

struct AnalyticsDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Town.self, Fossil.self, Bug.self, Fish.self, Art.self, configurations: config)
        
        let context = container.mainContext
        
        // Create sample data for preview
        let town = Town(name: "PreviewTown")
        context.insert(town)
        
        let dataManager = DataManager(modelContext: context)
        
        return AnalyticsDashboardView()
            .environmentObject(dataManager)
    }
}
