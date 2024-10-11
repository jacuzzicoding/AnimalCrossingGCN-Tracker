AnimalCrossingGCN-Tracker - Project Document

Version: v1.10.07.24.a
Release Date: October 7, 2024
Author: Brock Jenkinson

Project Overview

The AnimalCrossingGCN-Tracker is a companion app designed for players of the original Animal Crossing on the GameCube. The app assists players in tracking museum collectibles, including fossils, bugs, and fish. Built using Swift and SwiftUI, the app leverages SwiftData for persistent storage across all collectibles. It is designed to work seamlessly across iPhone, iPad, and macOS devices.

The current version, v1.10.07.24.a, introduces a new search feature, allowing users to easily find items within their collections, and includes a fix for how the bug season information is displayed.

File Structure

ContentView.swift manages the primary view where fossils, bugs, and fish are displayed. It includes the newly added search bar and adapts layouts for iPhones, iPads, and macOS devices using NavigationStack and NavigationSplitView. Users can toggle donation statuses, view detailed information, and search for specific collectibles.

Fossil.swift defines the Fossil data model, containing the fossil’s name, optional part information, and donation status. It provides a method to pre-populate the app with all 25 fossils from Animal Crossing (GameCube).

Bug.swift defines the Bug data model, including the bug’s name, season availability, and donation status. It also pre-populates the app with a list of 40 bugs. The recent update fixes how the season text is displayed.

Fish.swift defines the Fish data model, containing the fish’s name, season availability, location (river, sea, or pond), and donation status. It pre-populates the app with a list of 40 fish.

AnimalCrossingGCN_TrackerApp.swift is the entry point of the app, responsible for managing the app’s lifecycle and initializing the SwiftData model container, which in turn loads and displays the primary ContentView.

AnimalCrossingGCN_TrackerTests.swift and AnimalCrossingGCN_TrackerUITests.swift provide basic unit and UI tests to ensure the app’s functionality and interface work as expected.

Current Features (v1.10.07.24.a)

-The app comes pre-populated with 25 fossils, 40 bugs, and 40 fish. Users can mark items as donated or not, with progress saved between sessions using SwiftData. The recently added search bar allows users to search through fossils, bugs, and fish by name, streamlining navigation.

-The app uses NavigationStack for iPhones and NavigationSplitView for iPads and macOS. This responsive user interface adapts to each device, ensuring a smooth experience for all users. A recent update also fixes how the bug season text is displayed, ensuring that information is shown cleanly and correctly.

-Persistent data storage ensures that user data for fossils, bugs, and fish is preserved between app sessions.

Tasks Completed in v1.10.07.24.a

-A search functionality has been added to help users quickly find fossils, bugs, and fish. The bug season display has been fixed to eliminate the “Optional(…)” issue, ensuring cleaner presentation. 

Issues & Limitations

-The delete function currently removes items permanently, with no option to restore them. A future update will either implement an add item function or remove the delete option altogether. 

-The DetailView feature is currently unavailable for iPhones, with plans to address this in future updates. 

-Art tracking has not been implemented yet but is planned for future releases.

Future Steps

-Art tracking will be introduced in a future update, allowing users to track art pieces from the original Animal Crossing. 

-Future features will also include filtering options for sorting collections by donation status, season availability, and collectible type (fossils, bugs, fish, and art).

-The app will soon introduce data visualization features. Users will be able to track donation times, with graphs and visual representations of their progress over time. The ability to toggle between different collectibles on the graphs (such as fossils, bugs, fish, and art) will provide a more interactive experience. 

-Future updates will also include summary statistics, such as total items donated and overall completion progress.

-Plans are in place to add a feature for importing and exporting user data, allowing users to back up and transfer their collection progress across devices. Localization options will be explored to support multiple languages, expanding accessibility for non-English speakers.

-Cross-Platform Support

The app has been designed for compatibility with iPhones, iPads, and macOS devices. SwiftData ensures persistent data storage across all platforms, maintaining a seamless user experience regardless of device.

Summary

Version v1.10.07.24.a introduces a search bar and significant improvements to the display of bug season data. With this update, the app provides an even more streamlined experience for tracking fossils, bugs, and fish, while laying the foundation for future features such as art tracking and data visualization.
