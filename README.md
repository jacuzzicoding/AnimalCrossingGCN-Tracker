AnimalCrossingGCN-Tracker - Project Document

Version: v0.4.2-alpha
Release Date: October 17, 2024
Author: Brock Jenkinson

Project Overview

The AnimalCrossingGCN-Tracker is a companion app I'm making as a passion project, and it helps players of the original Animal Crossing on the GameCube track their museum collectibles, including fossils, bugs, fish, and art. Built with Swift and SwiftUI, the app leverages SwiftData to ensure data persistence across iPhone, iPad, and macOS devices. It aims to provide players with a seamless tool for managing their collections across platforms.

Version v0.4.2-alpha addresses UI issues on iPhones and lays the groundwork for future image display in the art tracking feature.

File Structure

The project is structured into several key components:

	•	Main View (ContentView.swift): Manages the display of fossils, bugs, fish, and art with adaptive layouts for different devices (iPhones, iPads, macOS). Includes a search bar to quickly locate collectibles by name.
	•	Data Models:
	•	Fossil.swift: Defines the fossil model, containing the fossil name, optional part info, and donation status. Pre-populated with the 25 fossils available in the game.
	•	Bug.swift: Defines the bug model, including the bug’s name, season availability, and donation status. Pre-populated with 40 bugs and includes a bug season display fix.
	•	Fish.swift: Defines the fish model, including the fish’s name, season availability, location, and donation status. Pre-populated with 40 fish.
	•	Art.swift: Defines the art model, including the name, real-world counterpart, donation status, and the artist’s name. Pre-populated with 13 art pieces.
	•	Navigation and Persistence:
	•	The entry point is AnimalCrossingGCN_TrackerApp.swift, which manages the app lifecycle and initializes the SwiftData model container to ensure persistent data storage across sessions.
	•	Testing:
	•	AnimalCrossingGCN_TrackerTests.swift and AnimalCrossingGCN_TrackerUITests.swift handle unit and UI tests, ensuring the app functions correctly and the interface remains smooth across devices.

Current Features

The app supports full tracking of fossils, bugs, fish, and art, with pre-populated lists of items from the game. Users can:

	•	Toggle donation statuses.
	•	View detailed information for each collectible.
	•	Use the search functionality to quickly find items by name.
	•	Experience adaptive layouts for iPhones, iPads, and macOS devices.

v0.4.2-alpha New Updates:

This release resolves key navigation and UI issues, especially for iPhone users, and lays the foundation for future image display in the art section.

	•	Fixed iPhone Detail View: Resolved a UI issue causing the detail view to appear under the navigation bar by removing the .background modifier in compact size classes.
	•	Navigation Improvements: Replaced Button with NavigationLink in list sections for proper navigation. Separated toggle controls for marking items as donated to avoid navigation conflicts.
	•	Artist Names & Image Property: Added the original artist’s name in the art detail view, and introduced the imageName property for future updates where art images will be displayed.

Issues & Limitations

	•	Art Detail Images: While the groundwork for image display in the art section is in place, images are not yet available and remain commented out in the code.

Future Steps:

With the completion of all major museum sections, the focus will now shift to refining the user experience and introducing new features:

	•	Data Visualization: Upcoming releases will introduce graphs and visual progress tracking for each collectible category (fossils, bugs, fish, art).
	•	Filtering Options: The app will gain sorting and filtering capabilities based on donation status, season availability, and collectible type.
	•	Data Import/Export: Users will be able to back up and transfer their collection data between devices or after an app reset.
	•	Localization: Support for multiple languages will be added to improve accessibility for non-English-speaking players.
	•	Donation Date Tracking: A feature for tracking the date of each donation will be introduced, with future plans for displaying donation timelines.

Cross-Platform Support

The app ensures consistent performance and appearance across iPhones, iPads, and macOS devices using SwiftData for data persistence. NavigationStack and NavigationSplitView provide an adaptive, responsive experience for users on different platforms.

Summary

Version v0.4.2-alpha resolves iPhone detail view issues, introduces improved navigation, and sets the stage for future updates like art image display. With the completion of art tracking, the app now offers a comprehensive tool for managing all museum collectibles in Animal Crossing for GameCube. Future updates will focus on data visualization, filtering options, and enhanced usability.
