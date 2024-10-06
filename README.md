AnimalCrossingGCN-Tracker - Project Document

Version: v1.10.05.24.a

Release Date: October 5, 2024

Project Overview:

AnimalCrossingGCN-Tracker is a companion app designed for the original Animal Crossing on the GameCube. The app serves as a tool for players to track museum collectibles such as fossils, with plans to expand into bugs, fish, and art in future releases. It is built using Swift and SwiftUI for the user interface, and SwiftData for persistent storage.

File Structure:

ContentView.swift
-Manages the primary view where fossils are displayed in a list.
-Uses @Query to fetch fossil data from SwiftData and NavigationStack (iPhone) or NavigationSplitView (iPad/macOS) for smooth navigation.
-Provides functionality for toggling donation status and viewing detailed information about each fossil.

Fossil.swift
-Defines the Fossil data model, including the fossil name, part (optional), and donation status.
-Contains a getDefaultFossils() function that returns a predefined list of fossils.
-Also includes FossilDetailView, a view that displays detailed fossil information with a toggle for donation status.

AnimalCrossingGCN_TrackerApp.swift
-The entry point of the app, responsible for managing the app lifecycle and initializing the SwiftData model container.
-Loads and displays the primary view (ContentView.swift).

AnimalCrossingGCN_TrackerTests.swift & AnimalCrossingGCN_TrackerUITests.swift
-Provide basic unit and UI tests to ensure the app’s functionality and interface work as expected.

Current Features (v1.10.05.24.a):

-Fossil Tracking:
  -Users can mark fossils as donated or not donated.
  -The fossil tracking system includes all 25 fossils that are present in Animal Crossing (GameCube version). These fossils are pre-populated during the app’s       
   initial launch.
  -Fossils can be viewed, and their details are displayed, including the fossil name, part, and donation status.
  -Donation status is persisted using SwiftData, so changes are saved even after the app is closed.

-Dynamic User Interface
  -Uses NavigationStack for iPhone devices and NavigationSplitView for iPads and macOS.
  -Provides a responsive UI that adapts to the device being used, ensuring a clean and intuitive user experience.
  -The interface includes a toggle for donation status and detailed views for each fossil.

-Persistent Data Storage
  -Data is stored using SwiftData, ensuring that user progress (such as donation status) is saved and persists between app sessions.

Tasks Completed (v1.10.05.24.a):

  -Integration of SwiftData for persistent data storage.
  -A fully functional fossil tracking system with 25 fossils pre-populated and the ability to toggle donation status.
  -Implementation of NavigationStack (iPhone) and NavigationSplitView (iPad/macOS) for adaptive layouts.
  -Basic unit tests and UI tests to ensure data integrity and proper functioning of the interface.

Issues & Limitations (v1.10.05.24.a):

  -The app currently only supports fossil tracking. Future releases will include tracking for bugs, fish, and art.
  -Some UI limitations may be experienced on smaller iPhone screens, but the app remains fully functional.
  -The app must be run through Xcode and cannot be installed directly on a device via an app store.

Next Steps:

  -Tracking Expansion
  -Implement tracking for bugs, fish, and art in future versions.
  -Add features for search and filtering to make it easier to navigate the growing list of collectibles.

UI Enhancements
  -Provide richer detail views for each collectible category.
  -Improve overall app performance and user experience, especially for larger collections.

Additional Testing
  -Expand unit and UI tests to cover the new features and ensure robustness as the app evolves.

Notes:

Future updates will focus on expanding functionality, such as adding villager tracking, town customization, and Nook store upgrade monitoring.
As the app grows, further optimization and testing will be necessary to handle the increased complexity of the features.
