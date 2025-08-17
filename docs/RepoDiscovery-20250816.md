# Repo Discovery Report - AnimalCrossingGCN-Tracker
*Generated: August 16, 2025*

## Environment

**Swift Toolchain:**
- Apple Swift version 6.0.3 (swiftlang-6.0.3.1.10 clang-1600.0.30.1)
- Target: arm64-apple-macosx15.0
- Driver version: 1.115.1

**Xcode:**
- Version: 16.4 (Build 16F6)
- Developer Directory: /Applications/Xcode.app/Contents/Developer

**Available SDKs:**
- iOS 18.5, macOS 15.5, tvOS 18.5, watchOS 11.5
- visionOS 2.5, DriverKit 24.5
- All platforms include simulator variants

**Version Files:**
- No .swift-version file present
- No Package.swift (Xcode project only)

## Layout

**Project Type:** Xcode project (AnimalCrossingGCN-Tracker.xcodeproj)

**Directory Structure:**
```
AnimalCrossingGCN-Tracker/
├── App/                    # Application entry point & dependencies
├── Assets.xcassets/        # Asset catalog (1 asset bundle)
├── Documentation/          # Project documentation
├── Managers/              # Data & category managers
├── Models/                # SwiftData models & protocols
├── Protocols/             # Service protocols
├── Repositories/          # Data access layer
├── Services/              # Business logic layer
├── Utilities/             # Constants, DI container, styles
└── Views/                 # SwiftUI view hierarchy
```

## Targets and Settings

**Targets:**
- AnimalCrossingGCN-Tracker (main app)
- AnimalCrossingGCN-TrackerTests (unit tests)
- AnimalCrossingGCN-TrackerUITests (UI tests)

**Schemes:**
- AnimalCrossingGCN-Tracker (single scheme)

**Key Build Settings:**
- Architecture: arm64 x86_64 (universal)
- Deployment Target: iOS 18.0+ (minimum)
- Swift Version: Swift 5 (SWIFT_VERSION not explicitly overridden)
- Bundle ID: jacuzzicoding.AnimalCrossingGCN-Tracker
- Code Signing: Development team configured

## Dependencies

**Frameworks Used:**
- SwiftUI (primary UI framework)
- SwiftData (persistence layer)
- Charts (analytics visualization)
- Foundation (core utilities)

**Dependency Management:**
- No external package managers (SPM, CocoaPods, Carthage)
- All dependencies are system frameworks
- Uses internal dependency injection system

**Architecture Pattern:**
- Repository pattern for data access
- Service layer for business logic  
- MVVM with dependency injection
- Protocol-oriented design throughout

## Entry Points

**Main Entry Point:**
- `@main` struct at AnimalCrossingGCN_TrackerApp.swift:14
- SwiftUI App lifecycle (no AppDelegate/SceneDelegate)

**App Structure:**
- SwiftUI-based architecture
- ContentView as root view with tab navigation
- Dependency injection configured in AppDependencies
- SwiftData ModelContainer setup in main app

## Data Layer

**SwiftData Models:**
- `@Model` classes: Fossil, Bug, Fish, Art, Town (5 core models)
- All located in Models/Core/ directory

**Key Model Characteristics:**
- Fish.swift:12, Bug.swift:12, Art.swift:12, Fossil.swift:12, Town.swift:5
- UUID-based unique identifiers (@Attribute(.unique))
- Conform to protocols: DonationTimestampable, TownLinkable

**ACGame Enum:**
```swift
enum ACGame: String, CaseIterable, Codable {
    case ACGCN = "Animal Crossing GameCube"
    case ACWW = "Animal Crossing: Wild World" 
    case ACCF = "Animal Crossing: City Folk"
    case ACNL = "Animal Crossing: New Leaf"
    case ACNH = "Animal Crossing: New Horizons"
}
```
- Located: AnimalCrossingGCN-Tracker/Models/Core/Games.swift:4
- Properly implements Codable for SwiftData compatibility
- No enum storage issues detected

**SwiftData Usage:**
- Extensive SwiftData imports across 32+ files
- Repository pattern abstracts SwiftData details
- Proper ModelContainer configuration in app

## Resources

**Assets:**
- 1 asset bundle in Assets.xcassets
- AppIcon and AccentColor configured
- Preview assets available

**Configuration Files:**
- 7 JSON/plist files (mostly Xcode metadata)
- No external CSV or data resource files
- Asset generation enabled for Swift symbols

## Tests

**Test Infrastructure:**
- Unit test target: AnimalCrossingGCN-TrackerTests
- UI test target: AnimalCrossingGCN-TrackerUITests
- Tests exist but build currently fails

**Test Run Result:**
```
Error: Missing argument for parameter 'viewModel' in call
Testing cancelled because the build failed.
** TEST FAILED **
```

## Buildability

**Build Attempt:**
- iOS Simulator build attempted on iPhone 16
- **Status: BUILD FAILS** due to compilation errors

**Primary Issues:**
1. Missing viewModel parameter in MainTabView construction
2. Multiple Swift compilation errors in FossilDetailView, MainTabView
3. SwiftCompile errors across 7 key files

**Warnings Detected:**
- DonationService.swift: 5 warnings about unreachable catch blocks
- No calls to throwing functions in try expressions

## Git

**Status:**
- Current branch: working-branch (no commits yet)
- Repository has multiple feature branches:
  - code-cleanup, feature-analytics, feature-homescreen
  - feature/dates, final-v7, main
- All files are staged (A) or modified (AM)
- 3 untracked files: CategoryManager.swift, CategorySection.swift, CollectibleRow.swift

**Recent Commits (from other branches):**
- Latest work on analytics features and UI improvements
- Version tags suggest active development (v0.7.0-alpha-preview-x)

## Swift Compatibility

**Modern Features in Use:**
- SwiftData (requires iOS 17+/macOS 14+)
- SwiftUI with modern APIs
- DispatchQueue.async patterns (could use async/await)
- No @MainActor usage detected in current files

**Compatibility Risks:**
- **HIGH**: iOS 18.0 minimum deployment target very restrictive
- SwiftData @Model macro requires iOS 17+
- Some modern SwiftUI APIs may not be backwards compatible
- Swift 6.0.3 toolchain vs older deployment targets

**API Usage:**
- Charts framework (iOS 16+)
- UUID @Attribute(.unique) (SwiftData specific)
- Modern SwiftUI navigation patterns

## Quick Wins

1. **Fix Build Errors** - MainTabView.swift missing viewModel parameter (high priority)
2. **Add Missing Files** - Stage untracked CategoryManager.swift, CategorySection.swift, CollectibleRow.swift  
3. **Test Infrastructure** - Fix test compilation to enable CI/CD pipeline
4. **Remove Dead Code** - Clean up unreachable catch blocks in DonationService.swift
5. **Deployment Target** - Consider lowering iOS 18.0 requirement to iOS 17.0 for broader compatibility
6. **Modernize Async** - Replace DispatchQueue.async with async/await patterns in DataManager.swift:X
7. **Documentation** - Complete missing inline documentation for public APIs
8. **Performance** - Add @MainActor to view models for UI thread safety
9. **Error Handling** - Implement proper throwing methods in repositories to fix service warnings
10. **Asset Audit** - Verify all asset references and add missing icons for ACGame.icon values

**Critical Path:** Fix MainTabView compilation error → Run successful build → Enable testing → Commit working state

---
*This report identifies 10 immediate action items with the first 3 being blocking issues for basic functionality.*