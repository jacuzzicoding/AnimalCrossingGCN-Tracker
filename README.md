# AnimalCrossingGCN-Tracker
* Version: v0.6.5-alpha-phase1 (Testing Build)
* Last Updated: February 25th, 2025
* Author: Brock Jenkinson (@jacuzzicoding)

## Project Overview
The AnimalCrossingGCN-Tracker is a comprehensive companion app for tracking Animal Crossing GameCube museum donations. Built with Swift and SwiftUI, the app leverages SwiftData to provide seamless cross-platform support for iPhone, iPad, and macOS devices.

Version v0.6.5-alpha focuses on architectural improvements to increase code modularity and maintainability. This testing build (phase1) has completed the model-view separation and is proceeding with implementing the repository pattern.

## Features

### Core Functionality
* Complete museum donation tracking:
  * Fossils (25 items)
  * Bugs (40 items)
  * Fish (40 items)
  * Art (13 pieces)
* Donation timestamp system
* Town-based collection tracking
* Modern floating category navigation
* Enhanced search functionality
* SwiftData integration for persistence

### Technical Improvements
* Architectural enhancements (v0.6.5-alpha):
  * ✅ Phase 1: Complete separation of models from views
  * ⬜ Phase 2: Repository pattern implementation (in progress)
  * ⬜ Phase 3: Enhanced model relationships and services
* Comprehensive donation tracking system:
  * Timestamp integration across all models
  * DetailMoreInfoView implementation
  * Enhanced SwiftData model updates
* Backend preparation for future multi-game support:
  * ACGame enum system implementation
  * Version-specific data structures
  * Cross-game item availability framework
* Enhanced data models with town tracking
* Improved item organization by town

### UI Components
* DetailMoreInfoView for donation timestamps
* Floating category switcher with custom icons
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
└── Utilities/
    └── Various utility files
```

## Development Status

### Current Build Progress
* **v0.6.5-alpha-phase1 (February 25, 2025)**
  * ✅ Completed Phase 1: Model-View Separation
  * ✅ Created DetailViews for each model type
  * ✅ Removed view code from all model files
  * ✅ Fixed protocol conformance
  * ✅ Verified with successful compilation and testing

* **Next Development Phases**
  * ⬜ Phase 2: Repository Pattern Implementation
  * ⬜ Phase 3: Model Relationship Enhancement

### Long-term Roadmap
* v0.7.0 planned for early 2025
* Advanced filtering and donation visualization
* Enhanced town-based tracking
* Complete multi-game support
* UI improvements and transition animations

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
* Xcode 15+
* iOS 17.0+
* macOS 14.0+
* SwiftUI and SwiftData knowledge for contributions

## Contributing
This project welcomes community contributions. If anyone happens to see this, please report any issues or submit pull requests through the project's GitHub repository.

## License
MIT License
