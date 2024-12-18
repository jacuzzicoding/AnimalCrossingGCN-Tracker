# AnimalCrossingGCN-Tracker
Version: v0.6.0-alpha (Development)
Last Updated: December 16th, 2024
Author: Brock Jenkinson (@jacuzzicoding)

## Project Overview
The AnimalCrossingGCN-Tracker is a comprehensive companion app for tracking Animal Crossing GameCube museum donations. Built with Swift and SwiftUI, the app leverages SwiftData to provide seamless cross-platform support for iPhone, iPad, and macOS devices.

Version v0.6.0-alpha introduces town tracking functionality and lays the groundwork for future multi-game support while maintaining the streamlined interface introduced in v0.5.0.

## Features

### Core Functionality
* Complete museum donation tracking:
  * Fossils (25 items)
  * Bugs (40 items)
  * Fish (40 items)
  * Art (13 pieces)
* Town-based collection tracking (NEW)
* Modern floating category navigation
* Enhanced search functionality
* SwiftData integration for persistence

### Technical Improvements
* Backend preparation for future multi-game support:
  * ACGame enum system implementation
  * Version-specific data structures
  * Cross-game item availability framework
* Enhanced data models with town tracking
* Improved item organization by town

### UI Components
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
│   ├── ACGame.swift
│   ├── CollectibleItem.swift
│   ├── Fossil.swift
│   ├── Bug.swift
│   ├── Fish.swift
│   └── Art.swift
├── Views/
│   ├── Main/
│   │   ├── ContentView.swift
│   │   └── CategoryView.swift
│   ├── Components/
│   │   ├── FloatingCategorySwitcher.swift
│   │   ├── CollectibleRow.swift
│   │   └── CategorySection.swift
│   └── Detail/
│       ├── FossilDetailView.swift
│       ├── BugDetailView.swift
│       ├── FishDetailView.swift
│       └── ArtDetailView.swift
└── Managers/
    └── DataManager.swift
```

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

## Known Issues
* Search limited to current category
* No transition animations for category switches
* Additional macOS performance testing needed

## Technical Requirements
* Xcode 15+
* iOS 17.0+
* macOS 14.0+
* SwiftUI and SwiftData knowledge for contributions

## Development Status
* Currently in active development (v0.6.1-alpha coming next)
* New town-based tracking system
* Backend preparation for future multi-game support
* Working toward advanced filtering and UI improvements

## Contributing
This project welcomes community contributions. If anyone happens to see this, please report any issues or submit pull requests through the project's GitHub repository.

## License
MIT License
