# AnimalCrossingGCN-Tracker
* Version: v0.7.0-alpha-preview-4
* Last Updated: April 6, 2025
* Author: Brock Jenkinson (@jacuzzicoding)

> **Important Update**: v0.7.0-alpha-preview-4 adds CSV export functionality to the analytics system, allowing you to export your museum collection data!

## Project Overview
The AnimalCrossingGCN-Tracker is a comprehensive companion app for tracking Animal Crossing GameCube museum donations. Built with Swift and SwiftUI, the app leverages SwiftData to provide seamless cross-platform support for iPhone, iPad, and macOS devices.

Version v0.7.0-alpha-preview-4 builds upon the fixed analytics functionality from v0.7.0-alpha-preview-3 by adding CSV export capabilities, allowing users to share their collection data and analytics with external applications.

## Features

### Core Functionality
* Complete museum donation tracking:
  * Fossils (25 items)
  * Bugs (40 items)
  * Fish (40 items)
  * Art (13 pieces)
* Enhanced donation timestamp system
* Advanced town-based collection tracking
* Progress tracking by category and overall
* Modern floating category navigation
* Enhanced search functionality
* SwiftData integration for persistence

### Analytics Features (Now with Export!)
* **NEW**: CSV export of analytics data (monthly activities, category completion, seasonal data)
* **NEW**: Platform-specific sharing options (iOS share sheet, macOS Finder integration)
* **NEW**: Custom filename options for exports
* Working donation timeline visualization
* Accurate category completion charts
* Seasonal availability analysis with real data
* Progress tracking dashboard showing correct percentages
* Time period filtering options
* Interactive chart components

### Technical Improvements
* Architectural enhancements:
  * ✅ Phase 1: Complete separation of models from views
  * ✅ Phase 2: Repository pattern implementation
  * ✅ Phase 3: Enhanced model relationships and service layer
  * ✅ Phase 4: Functional analytics with proper data visualization
  * ✅ Phase 5: Data export capabilities with service architecture
* **New Export Service System**:
  * Protocol-based design for extensibility
  * Standardized CSV formatting with proper headers and delimiters
  * Platform-specific sharing implementations
  * Background thread processing for better performance
* **Town-Item Linking System**:
  * Ensures proper relationships between collectibles and towns
  * Uses efficient lookup sets for performance
  * Maintains game compatibility
  * Automatically runs when app starts or town changes
* Enhanced Analytics Service:
  * Completely rewritten data processing
  * Robust handling of items with and without donation dates
  * Better seasonal data calculations
  * Improved filtering for timeline data
  * Added caching for better performance

### UI Components
* DetailMoreInfoView for donation timestamps
* Floating category switcher with custom icons
* Town-specific collection views
* Streamlined navigation system
* Refined search functionality
* Platform-specific optimizations
* Working analytics dashboard with functional chart visualizations
* Interactive timeline and category charts
* **NEW**: Export options interface with format selection
* **NEW**: Platform-specific sharing sheets

## File Structure
```
AnimalCrossingGCN-Tracker/
├── App/
│   └── AnimalCrossingGCN_TrackerApp.swift
├── Models/
│   ├── Core/
│   │   ├── Item.swift
│   │   ├── Games.swift
│   │   ├── Town.swift
│   │   ├── Fossil.swift
│   │   ├── Bug.swift
│   │   ├── Fish.swift
│   │   └── Art.swift
│   ├── DTOs/
│   │   ├── CollectibleDTO.swift
│   │   └── TownDTO.swift
│   ├── Extensions/
│   │   └── Various model extensions
│   ├── Protocols/
│   │   └── DonationTimestampable.swift
│   └── View Models/
│       └── Various view models
├── Views/
│   ├── ContentView.swift
│   ├── ContentView+Analytics.swift
│   ├── MainListView.swift
│   ├── DetailMoreInfoView.swift
│   ├── EditTownView.swift
│   ├── FloatingCategorySwitcher.swift
│   ├── Analytics/
│   │   ├── AnalyticsDashboardView.swift
│   │   └── ExportOptionsView.swift
│   ├── Utilities/
│   │   └── ShareSheet.swift
│   └── DetailViews/
│       ├── FossilDetailView.swift
│       ├── BugDetailView.swift
│       ├── FishDetailView.swift
│       └── ArtDetailView.swift
├── Managers/
│   └── DataManager.swift
├── Repositories/
│   ├── BaseRepository.swift
│   ├── RepositoryProtocols.swift
│   ├── FossilRepository.swift
│   ├── BugRepository.swift
│   ├── FishRepository.swift
│   ├── ArtRepository.swift
│   └── TownRepository.swift
├── Services/
│   ├── DonationService.swift
│   ├── AnalyticsService.swift
│   └── ExportService.swift
└── Utilities/
    └── Various utility files
```

## Development Status

### Current Build Progress
* **v0.7.0-alpha-preview-4 (April 6, 2025)**
  * ✅ **Added Analytics Export Functionality**
    * ✅ Implemented flexible `ExportService` architecture
    * ✅ Created CSV export with proper formatting
    * ✅ Added platform-specific sharing options
    * ✅ Implemented user-friendly export options UI
  * ✅ Cross-platform compatibility
    * ✅ iOS-specific share sheet implementation
    * ✅ macOS file handling and Finder integration
    * ✅ Responsive design for all screen sizes
  * ⬜ PNG/PDF export for charts and visualizations
  * ⬜ Advanced filtering options

* **v0.7.0-alpha-preview-3 (February 28, 2025)**
  * ✅ **Fixed Analytics Functionality**
    * ✅ Implemented town-item linking system
    * ✅ Rewrote analytics data processing
    * ✅ Fixed date handling for timeline charts
    * ✅ Corrected category progress calculations
    * ✅ Improved seasonal analysis
  * ✅ Enhanced UI components
    * ✅ Simplified timeline view
    * ✅ Fixed chart data display
    * ✅ Improved empty states with helpful messages
    * ✅ Added better error handling

* **v0.7.0-alpha-preview-2 (February 27, 2025)**
  * ✅ Initial Analytics GUI implementation
  * ✅ UI layout enhancements

* **v0.7.0-alpha-preview (February 26, 2025)**
  * ✅ Completed Phases 1-3 of architectural improvements

### Breaking Changes
Version v0.7.0-alpha-preview introduced breaking changes that impact save compatibility:
1. Enhanced Town model with additional properties
2. ID-based relationship system instead of direct references
3. Modified data structure for all collectible items

### Next Development Phase
* v0.7.0-alpha full release plans:
  * Complete PNG/PDF export functionality
  * New Home Screen design with user choice-driven navigation
  * Global search functionality with cross-category search
  * Villager support with GameCube villagers database
  * Unit tests for services and repositories
  * Performance optimizations for analytics calculations

### Long-term Roadmap
* v0.7.x: Multi-game support beyond GameCube version
* v0.8.0: Custom hand-drawn icons and thumbnails
* v0.9.0: Enhanced iOS features (haptics, widgets)
* v1.0.0: Full-featured Animal Crossing companion app

## Platform Support

### iOS/iPadOS
* Full feature support
* Optimized floating UI elements
* Native platform interactions
* Responsive layouts for all screen sizes
* Functional SwiftCharts visualizations for analytics
* Share sheet integration for exporting data

### macOS
* Complete feature parity with iOS
* Enhanced keyboard navigation
* Native menu bar integration
* Platform-specific UI refinements
* Optimized chart layouts for desktop use
* Finder integration for exported files

## Technical Requirements
* Xcode 15.5+
* iOS 17.0+
* macOS 14.0+
* SwiftUI and SwiftData knowledge for contributions
* Swift Charts for analytics visualizations

## Known Issues
* PNG/PDF export of charts is not yet implemented (only CSV export is available)
* Large datasets may take longer to export without detailed progress indication
* Export UI is functional but will be enhanced in future updates
* No caching mechanism for exported data, requiring re-processing for each export
* Minor UI alignment issues on smaller iPhone screens
* Chart labels may overlap with many data points in timeline view
* Seasonal analysis doesn't account for hemisphere differences (Northern only)

## Contributing
This project welcomes community contributions. If anyone happens to see this, please report any issues or submit pull requests through the project's GitHub repository.

## License
MIT License