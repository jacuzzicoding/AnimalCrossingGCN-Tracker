# AnimalCrossingGCN-Tracker

Version: v0.5.1-alpha (Development)  
Last Updated: December 7th, 2024  
Author: Brock Jenkinson (@jacuzzicoding)

## Project Overview

The AnimalCrossingGCN-Tracker is a comprehensive companion app for Animal Crossing GameCube players to track their museum donations. Built with Swift and SwiftUI, the app leverages SwiftData to provide seamless cross-platform support for iPhone, iPad, and macOS devices.

Version v0.5.1-alpha introduces a major file structure reorganization while maintaining all functionality from v0.5.0, including the floating category system and enhanced UI components.

## File Structure

The project follows a modular organization pattern:

```
AnimalCrossingGCN-Tracker/
├── App/
│   └── AnimalCrossingGCN_TrackerApp.swift
├── Models/
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

## Features

### Core Functionality
- Complete museum donation tracking
- Support for all collectible categories:
  - Fossils (25 items)
  - Bugs (40 items)
  - Fish (40 items)
  - Art (13 pieces)
- Modern floating category navigation
- Enhanced search functionality
- Cross-platform compatibility
- SwiftData integration for persistence

### UI Components
- Floating category selector with custom icons
- Improved item display and spacing
- Streamlined navigation system
- Refined search functionality
- Platform-specific optimizations

## Platform Support

### iOS/iPadOS
- Full feature support
- Optimized floating UI elements
- Native platform interactions
- Responsive layouts for all screen sizes

### macOS
- Basic functionality implemented
- Known limitations:
  - Additional testing required
  - UI refinements pending

## Known Issues
- Search limited to current category

## Technical Requirements
- Xcode 15+
- iOS 17.0+
- macOS 14.0+
- SwiftUI and SwiftData knowledge for contributions

## Development Status
- Currently in development (v0.5.1-alpha)
- Focused on code structure reorganization
- Maintaining existing functionality from v0.5.0
- Working toward platform stability improvements

## Contributing
This project welcomes community contributions. Please report any issues or submit pull requests through the project's GitHub repository.

## License
MIT License.
