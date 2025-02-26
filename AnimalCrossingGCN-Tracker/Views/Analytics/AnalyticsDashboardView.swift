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

// Main Dashboard View
struct AnalyticsDashboardView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @State private var timelineData: [MonthlyDonationActivity] = []
    @State private var completionData: CategoryCompletionData?
    @State private var seasonalData: SeasonalData?
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        VStack {
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
    }
    
    private func loadData() {
        if dataManager.currentTown != nil {
            // Load actual data from the DataManager
            timelineData = dataManager.getDonationActivityByMonth()
            completionData = dataManager.getCategoryCompletionData()
            seasonalData = dataManager.getSeasonalData()
        }
    }
    
    // Dashboard card views
    private func overallProgressCard(completion: CategoryCompletionData) -> some View {
        VStack(alignment: .leading) {
            Text("Museum Progress")
                .font(.headline)
            
            HStack {
                Text("\(completion.totalDonated) of \(completion.totalCount) items donated")
                Spacer()
                Text("\(Int(completion.totalProgress * 100))%")
                    .bold()
            }
            
            ProgressView(value: completion.totalProgress)
                .tint(.purple)
        }
        .padding()
        .hierarchicalBackground()
    }
    
    private func recentActivityCard(data: [MonthlyDonationActivity]) -> some View {
        VStack(alignment: .leading) {
            Text("Recent Activity")
                .font(.headline)
            
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
        .padding()
        .hierarchicalBackground()
    }
    
    private func currentSeasonCard(season: SeasonalCompletion) -> some View {
        VStack(alignment: .leading) {
            Text("Currently Available")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Bugs")
                        .font(.subheadline)
                    HStack {
                        Image(systemName: "ant.fill")
                            .foregroundColor(.green)
                        Text("\(season.bugDonated) of \(season.bugCount)")
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Fish")
                        .font(.subheadline)
                    HStack {
                        Image(systemName: "fish.fill")
                            .foregroundColor(.blue)
                        Text("\(season.fishDonated) of \(season.fishCount)")
                    }
                }
            }
            
            Text("This month: \(Int(season.totalProgress * 100))% complete")
                .font(.caption)
                .padding(.top, 4)
        }
        .padding()
        .hierarchicalBackground()
    }
    
    private func categoryBreakdownCard(completion: CategoryCompletionData) -> some View {
        VStack(alignment: .leading) {
            Text("Categories")
                .font(.headline)
            
            HStack {
                CategoryMiniProgress(label: "Fossils", progress: completion.fossilProgress, color: .brown)
                CategoryMiniProgress(label: "Bugs", progress: completion.bugProgress, color: .green)
                CategoryMiniProgress(label: "Fish", progress: completion.fishProgress, color: .blue)
                CategoryMiniProgress(label: "Art", progress: completion.artProgress, color: .purple)
            }
        }
        .padding()
        .hierarchicalBackground()
    }
}

// Helper view for mini progress indicators
struct CategoryMiniProgress: View {
    let label: String
    let progress: Double
    let color: Color
    
    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
            
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 5)
                    .frame(width: 40, height: 40)
                
                Circle()
                    .trim(from: 0, to: CGFloat(progress))
                    .stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 10))
                    .bold()
            }
        }
    }
}

// MARK: - Chart Views

// Timeline Chart View
struct DonationTimelineView: View {
    let timelineData: [MonthlyDonationActivity]
    @State private var selectedTimeFrame: TimeFrame = .year
    
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
            return timelineData.filter { $0.month >= threeMonthsAgo }
        case .halfYear:
            let sixMonthsAgo = calendar.date(byAdding: .month, value: -6, to: now)!
            return timelineData.filter { $0.month >= sixMonthsAgo }
        case .year:
            let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: now)!
            return timelineData.filter { $0.month >= oneYearAgo }
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
                Text("No donation data available for this time period")
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .hierarchicalBackground()
            } else {
                Chart {
                    ForEach(filteredData) { activity in
                        BarMark(
                            x: .value("Month", activity.formattedMonth),
                            y: .value("Fossils", activity.fossilCount)
                        )
                        .foregroundStyle(Color.brown)
                        
                        BarMark(
                            x: .value("Month", activity.formattedMonth),
                            y: .value("Bugs", activity.bugCount)
                        )
                        .foregroundStyle(Color.green)
                        
                        BarMark(
                            x: .value("Month", activity.formattedMonth),
                            y: .value("Fish", activity.fishCount)
                        )
                        .foregroundStyle(Color.blue)
                        
                        BarMark(
                            x: .value("Month", activity.formattedMonth),
                            y: .value("Art", activity.artCount)
                        )
                        .foregroundStyle(Color.purple)
                    }
                }
                .chartForegroundStyleScale([
                    "Fossils": Color.brown,
                    "Bugs": Color.green,
                    "Fish": Color.blue,
                    "Art": Color.purple
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
                        .tint(.purple)
                    
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
                        .foregroundStyle(Color.brown)
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
                        .foregroundStyle(Color.blue)
                        .opacity(0.8)
                        
                        SectorMark(
                            angle: .value("Art", completionData.artCount),
                            innerRadius: .ratio(0.6),
                            angularInset: 1.5
                        )
                        .foregroundStyle(Color.purple)
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
                        color: .brown
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
                        color: .blue
                    )
                    
                    CategoryProgressView(
                        label: "Art",
                        progress: completionData.artProgress,
                        donated: completionData.artDonated,
                        total: completionData.artCount,
                        color: .purple
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
        "Jan": .blue,
        "Feb": .blue,
        "Mar": .green,
        "Apr": .green,
        "May": .green,
        "Jun": .yellow,
        "Jul": .yellow,
        "Aug": .yellow,
        "Sep": .orange,
        "Oct": .orange,
        "Nov": .orange,
        "Dec": .blue
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
                                .tint(.blue)
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
                    .foregroundStyle(Color.blue)
                }
            }
            .chartForegroundStyleScale([
                "Bugs": Color.green,
                "Fish": Color.blue
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
            .foregroundColor(.blue)
            
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
