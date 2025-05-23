import SwiftUI
import Combine

struct SeasonalItem: Identifiable {
    let id: String
    let name: String
    let description: String
    let isLeaving: Bool
}

class HomeViewModel: ObservableObject {
    @Published var categoryCompletion: CategoryCompletionData?
    @Published var seasonalItems: [SeasonalItem] = []
    @Published var recentDonations: [DonationItem] = []
    @Published var errorState: ErrorState = .none
    
    private var dataManager: DataManager
    private let analyticsService: AnalyticsServiceProtocol
    private let donationService: DonationServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(dataManager: DataManager, analyticsService: AnalyticsServiceProtocol, donationService: DonationServiceProtocol) {
        self.dataManager = dataManager // Keep DataManager for now, or refactor to remove direct dependency
        self.analyticsService = analyticsService
        self.donationService = donationService
        loadAllData()
        // Listen for changes to currentTown and reload data
        dataManager.$currentTown.sink { [weak self] _ in
            self?.loadAllData()
        }.store(in: &cancellables)
    }
    
    func loadAllData() {
        loadCategoryCompletion()
        loadSeasonalItems()
        loadRecentDonations()
    }
    
    func loadCategoryCompletion() {
        do {
            self.categoryCompletion = try dataManager.getCategoryCompletionData()
            self.errorState = .none
        } catch {
            self.categoryCompletion = nil
            self.errorState = .dataLoadFailed("Failed to load collection status.")
        }
    }
    
    func loadSeasonalItems() {
        // Use similar logic as in SeasonalHighlightsCard
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let monthAbbreviations = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let currentMonthAbbr = monthAbbreviations[currentMonth - 1]
        var items: [SeasonalItem] = []
        do {
            let bugs = dataManager.getBugsForCurrentTown()
            let availableBugs = bugs.filter { $0.season?.contains(currentMonthAbbr) == true }
            for bug in availableBugs.prefix(2) {
                let isLeaving = isLeavingSoon(season: bug.season ?? "", currentMonth: currentMonthAbbr)
                let description = isLeaving ? "Leaving soon!" : "Available now!"
                items.append(SeasonalItem(id: bug.id.uuidString, name: bug.name, description: description, isLeaving: isLeaving))
            }
            let fish = dataManager.getFishForCurrentTown()
            let availableFish = fish.filter { $0.season.contains(currentMonthAbbr) }
            for fish in availableFish.prefix(2) {
                let isLeaving = isLeavingSoon(season: fish.season, currentMonth: currentMonthAbbr)
                let description = isLeaving ? "Leaving soon!" : "Available now!"
                items.append(SeasonalItem(id: fish.id.uuidString, name: fish.name, description: description, isLeaving: isLeaving))
            }
            if items.isEmpty {
                items = [
                    SeasonalItem(id: "1", name: "Common Butterfly", description: "Available Now!", isLeaving: false),
                    SeasonalItem(id: "2", name: "Mole Cricket", description: "Leaving soon!", isLeaving: true),
                    SeasonalItem(id: "3", name: "Emperor Butterfly", description: "Coming next month!", isLeaving: false)
                ]
            }
            self.seasonalItems = items
        } catch {
            self.seasonalItems = []
            self.errorState = .dataLoadFailed("Failed to load seasonal items.")
        }
    }
    
    func loadRecentDonations() {
        // Use similar logic as in RecentDonationsCard
        var donatedItems: [(name: String, date: Date, color: Color)] = []
        do {
            let fossils = dataManager.getFossilsForCurrentTown().filter { $0.isDonated && $0.donationDate != nil }
            for fossil in fossils {
                if let date = fossil.donationDate {
                    let name = fossil.part != nil ? "\(fossil.name) \(fossil.part!)" : fossil.name
                    donatedItems.append((name: name, date: date, color: .acMuseumBrown))
                }
            }
            let bugs = dataManager.getBugsForCurrentTown().filter { $0.isDonated && $0.donationDate != nil }
            for bug in bugs {
                if let date = bug.donationDate {
                    donatedItems.append((name: bug.name, date: date, color: .green))
                }
            }
            let fish = dataManager.getFishForCurrentTown().filter { $0.isDonated && $0.donationDate != nil }
            for fish in fish {
                if let date = fish.donationDate {
                    donatedItems.append((name: fish.name, date: date, color: .acOceanBlue))
                }
            }
            let art = dataManager.getArtForCurrentTown().filter { $0.isDonated && $0.donationDate != nil }
            for art in art {
                if let date = art.donationDate {
                    donatedItems.append((name: art.name, date: date, color: .acBlathersPurple))
                }
            }
            donatedItems.sort { $0.date > $1.date }
            self.recentDonations = donatedItems.prefix(4).map { item in
                DonationItem(title: item.name, time: relativeTimeString(from: item.date), color: item.color)
            }
        } catch {
            self.recentDonations = []
            self.errorState = .dataLoadFailed("Failed to load recent donations.")
        }
    }
    
    private func isLeavingSoon(season: String, currentMonth: String) -> Bool {
        let monthAbbreviations = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        guard let currentIndex = monthAbbreviations.firstIndex(of: currentMonth) else { return false }
        let nextMonthIndex = (currentIndex + 1) % 12
        let nextMonth = monthAbbreviations[nextMonthIndex]
        return season.contains(currentMonth) && !season.contains(nextMonth)
    }
    
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
    
    // User action handlers can be added here as needed
}
