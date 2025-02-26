# AnimalCrossingGCN-Tracker
* Version: v0.7.0-alpha-preview
* Last Updated: February 26th, 2025
* Author: Brock Jenkinson (@jacuzzicoding)

> **Important Notice**: v0.7.0-alpha-preview breaks save compatibility with previous versions due to significant model relationship changes.

## Project Overview
The AnimalCrossingGCN-Tracker is a comprehensive companion app for tracking Animal Crossing GameCube museum donations. Built with Swift and SwiftUI, the app leverages SwiftData to provide seamless cross-platform support for iPhone, iPad, and macOS devices.

Version v0.7.0-alpha-preview (previously v0.6.5-alpha) has completed all three phases of architectural improvements, significantly enhancing code modularity, data relationships, and donation tracking capabilities.

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

### Technical Improvements
* Architectural enhancements (v0.7.0-alpha-preview):
  * ✅ Phase 1: Complete separation of models from views
  * ✅ Phase 2: Repository pattern implementation
  * ✅ Phase 3: Enhanced model relationships and service layer
* Comprehensive donation tracking system:
  * Complete timestamp integration across all models
  * Progress statistics by category
  * Service layer for donation management
  * Data Transfer Objects for clean presentation
* Backend preparation for future multi-game support:
  * ACGame enum system implementation
  * Version-specific data structures
  * Cross-game item availability framework
* Enhanced data models with expanded town properties:
  * Player name tracking
  * Game version association
  * Creation date logging
  * ID-based relationship system

### UI Components
* DetailMoreInfoView for donation timestamps
* Floating category switcher with custom icons
* Town-specific collection views
* Streamlined navigation system
* Refined search functionality
* Platform-specific optimizations

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
│   ├── MainListView.swift
│   ├── DetailMoreInfoView.swift
│   ├── EditTownView.swift
│   ├── FloatingCategorySwitcher.swift
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
│   └── DonationService.swift
└── Utilities/
    └── Various utility files
```

## Development Status

### Current Build Progress
* **v0.7.0-alpha-preview (February 26, 2025)**
  * ✅ Completed Phase 1: Model-View Separation
  * ✅ Completed Phase 2: Repository Pattern Implementation
  * ✅ Completed Phase 3: Model Relationship Enhancement
    * ✅ Enhanced Town model with additional properties
    * ✅ Implemented ID-based relationships between models
    * ✅ Created service layer for business logic
    * ✅ Implemented DTOs for data transformation
    * ✅ Added progress tracking functionality
    * ✅ Verified with successful compilation and testing

### Breaking Changes
This version introduces several breaking changes that impact save compatibility:
1. Enhanced Town model with additional properties
2. ID-based relationship system instead of direct references
3. Modified data structure for all collectible items

### Next Development Phase
* v0.7.0-alpha full release plans:
  * GUI for analytics and statistics
  * Enhanced visualization of donation data
  * Optimized performance for larger datasets
  * Unit tests for services and repositories
  * UI updates to leverage new data relationships

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

### macOS
* Complete feature parity with iOS
* Enhanced keyboard navigation
* Native menu bar integration
* Platform-specific UI refinements

## Technical Requirements
* Xcode 15.5+
* iOS 17.0+
* macOS 14.0+
* SwiftUI and SwiftData knowledge for contributions

## Contributing
This project welcomes community contributions. If anyone happens to see this, please report any issues or submit pull requests through the project's GitHub repository.

## License
MIT License
