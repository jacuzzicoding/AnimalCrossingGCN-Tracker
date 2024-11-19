AnimalCrossingGCN-Tracker - Project Document

Version: v0.4.3-alpha
Release Date: November 19, 2024
Author: Brock Jenkinson

Project Overview

The AnimalCrossingGCN-Tracker is a companion app designed to help players of the original Animal Crossing on the GameCube track their museum collectibles, including fossils, bugs, fish, and art. Built with Swift and SwiftUI, the app leverages SwiftData to ensure data persistence across iPhone, iPad, and macOS devices. It aims to provide players with a seamless tool for managing their collections across platforms.

Version v0.4.3-alpha introduces a major code reorganization to improve maintainability and provide a foundation for future features.

File Structure

The project is structured into several key components:

Main View (ContentView.swift): Manages the display of fossils, bugs, fish, and art with adaptive layouts for different devices (iPhones, iPads, macOS). Includes a search bar to quickly locate collectibles by name and uses a new generic CategorySection view for consistent item display.

Data Models:
CollectibleItem.swift: A new protocol that standardizes common properties across all collectible types.
Fossil.swift: Defines the fossil model, containing the fossil name, optional part info, and donation status. Pre-populated with the 25 fossils available in the game.
Bug.swift: Defines the bug model, including the bug's name, season availability, and donation status. Pre-populated with 40 bugs and includes a bug season display fix.
Fish.swift: Defines the fish model, including the fish's name, season availability, location, and donation status. Pre-populated with 40 fish.
Art.swift: Defines the art model, including the name, real-world counterpart, donation status, and the artist's name. Pre-populated with 13 art pieces.

Navigation and Persistence:
The entry point is AnimalCrossingGCN_TrackerApp.swift, which manages the app lifecycle and initializes the SwiftData model container to ensure persistent data storage across sessions. Navigation now uses an enum-based category system for improved type safety and maintainability.

Testing:
AnimalCrossingGCN_TrackerTests.swift and AnimalCrossingGCN_TrackerUITests.swift handle unit and UI tests, ensuring the app functions correctly and the interface remains smooth across devices.

Current Features

The app supports full tracking of fossils, bugs, fish, and art, with pre-populated lists of items from the game. Users can toggle donation statuses, view detailed information for each collectible, use the search functionality to quickly find items by name, and experience adaptive layouts for iPhones, iPads, and macOS devices. The addition of art tracking completed the four major museum sections, including real-world counterparts for famous art pieces like the Mona Lisa and Sunflowers.

v0.4.3-alpha Updates

This release focuses on internal code improvements and reorganization:
- Introduction of the CollectibleItem protocol to standardize item handling
- Replacement of string-based categories with an enum system
- Creation of a generic CategorySection view to reduce code duplication
- More centralized state management
- Maintained existing SwiftData integration and platform adaptations

Issues & Limitations

Currently, the app does not support the deletion of items from collections. Future updates may address this by either adding a delete function or removing the option entirely. While the groundwork for image display in the art section is in place, images are not yet available and remain commented out in the code.

Future Steps

With the completion of all major museum sections and recent code reorganization, the focus will now shift to refining the user experience and introducing new features. Upcoming releases will introduce data visualization with graphs and visual progress tracking for each collectible category (fossils, bugs, fish, art). The app will gain sorting and filtering capabilities based on donation status, season availability, and collectible type. Users will be able to back up and transfer their collection data between devices or after an app reset. Support for multiple languages will be added to improve accessibility for non-English-speaking players. A feature for tracking the date of each donation will be introduced, with future plans for displaying donation timelines.

Cross-Platform Support

The app ensures consistent performance and appearance across iPhones, iPads, and macOS devices using SwiftData for data persistence. NavigationStack and NavigationSplitView provide an adaptive, responsive experience for users on different platforms.

Summary

Version v0.4.3-alpha introduces major code reorganization and improvements to the app's architecture. While these changes aren't visible to users, they provide a stronger foundation for future features and improvements. The app continues to offer comprehensive tracking for all museum collectibles in Animal Crossing for GameCube, with future updates focused on data visualization, filtering options, and enhanced usability.
