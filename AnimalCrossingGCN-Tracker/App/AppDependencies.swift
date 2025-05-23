import Foundation
import SwiftData

/// Configures and manages app-wide dependencies
class AppDependencies {
    static func configure(with modelContext: ModelContext) -> DependencyContainer {
        let container = DependencyContainer()
        
        // Register repositories
        container.register(type: FossilRepository.self, instance: FossilRepository(modelContext: modelContext))
        container.register(type: BugRepository.self, instance: BugRepository(modelContext: modelContext))
        container.register(type: FishRepository.self, instance: FishRepository(modelContext: modelContext))
        container.register(type: ArtRepository.self, instance: ArtRepository(modelContext: modelContext))
        container.register(type: TownRepository.self, instance: TownRepository(modelContext: modelContext))
        
        // Register services
        container.register(type: DonationServiceProtocol.self) {
            DonationServiceImpl(modelContext: modelContext)
        }
        
        container.register(type: AnalyticsServiceProtocol.self) {
            let donationService = try! container.resolve(DonationServiceProtocol.self)
            return AnalyticsServiceImpl(modelContext: modelContext, donationService: donationService)
        }
        
        container.register(type: ExportServiceProtocol.self) {
            ExportServiceImpl()
        }
        
        container.register(type: GlobalSearchServiceProtocol.self) {
            GlobalSearchServiceImpl(modelContext: modelContext)
        }
        
        // Register DataManager
        container.register(type: DataManager.self) {
            DataManager(
                modelContext: modelContext,
                donationService: try! container.resolve(DonationServiceProtocol.self),
                analyticsService: try! container.resolve(AnalyticsServiceProtocol.self),
                exportService: try! container.resolve(ExportServiceProtocol.self),
                globalSearchService: try! container.resolve(GlobalSearchServiceProtocol.self)
            )
        }
        
        // Register ViewModels
        container.register(type: HomeViewModel.self) {
            HomeViewModel(
                dataManager: try! container.resolve(DataManager.self),
                analyticsService: try! container.resolve(AnalyticsServiceProtocol.self),
                donationService: try! container.resolve(DonationServiceProtocol.self)
            )
        }
        
        return container
    }
}