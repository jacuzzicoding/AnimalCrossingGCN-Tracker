# AnimalCrossingGCN-Tracker
* Version: v0.7.0-alpha-preview-3
* Last Updated: February 28th, 2025
* Author: Brock Jenkinson (@jacuzzicoding)

> **Important Update**: v0.7.0-alpha-preview-3 fixes the critical analytics functionality issue. Charts and statistics now properly display donation data and collection progress!

## Project Overview
The AnimalCrossingGCN-Tracker is a comprehensive companion app for tracking Animal Crossing GameCube museum donations. Built with Swift and SwiftUI, the app leverages SwiftData to provide seamless cross-platform support for iPhone, iPad, and macOS devices.

Version v0.7.0-alpha-preview-3 resolves the core issue that prevented analytics from displaying data correctly in previous versions. The application now properly shows donation timelines, category completion charts, and seasonal analysis with your actual museum data.

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

### Analytics Features (NEW: Now Fully Functional!)
* **Fixed**: Working donation timeline visualization
* **Fixed**: Accurate category completion charts
* **Fixed**: Seasonal availability analysis with real data
* **Fixed**: Progress tracking dashboard showing correct percentages
* Time period filtering options
* Interactive chart components
* Enhanced UI layout with improved component spacing

### Technical Improvements
* Architectural enhancements:
  * ✅ Phase 1: Complete separation of models from views
  * ✅ Phase 2: Repository pattern implementation
  * ✅ Phase 3: Enhanced model relationships and service layer
  * ✅ Phase 4: Functional analytics with proper data visualization
* **New Town-Item Linking System**:
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
* UI layout enhancements:
  * Improved FloatingCategorySwitcher with scrollable containers
  * Enhanced component spacing and alignment
  * Fixed overlap issues in nested views
  * Better cross-platform layout compatibility

### UI Components
* DetailMoreInfoView for donation timestamps
* Floating category switcher with custom icons
* Town-specific collection views
* Streamlined navigation system
* Refined search functionality
* Platform-specific optimizations
* **Working** analytics dashboard with functional chart visualizations
* Interactive timeline and category charts

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
│   │   └── AnalyticsDashboardView.swift
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
│   └── AnalyticsService.swift
└── Utilities/
    └── Various utility files
```

## Development Status

### Current Build Progress
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
  * ⬜ Add export functionality for analytics data
  * ⬜ Implement more advanced filtering options

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
  * Add analytics export functionality
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

### macOS
* Complete feature parity with iOS
* Enhanced keyboard navigation
* Native menu bar integration
* Platform-specific UI refinements
* Optimized chart layouts for desktop use

## Technical Requirements
* Xcode 15.5+
* iOS 17.0+
* macOS 14.0+
* SwiftUI and SwiftData knowledge for contributions
* Swift Charts for analytics visualizations

## Known Issues
* Minor UI alignment issues may exist on smaller iPhone screens
* Chart labels may overlap with many data points
* Export functionality for analytics data is not yet implemented
* Advanced filtering options are still in development

## Contributing
This project welcomes community contributions. If anyone happens to see this, please report any issues or submit pull requests through the project's GitHub repository.

## License
MIT License