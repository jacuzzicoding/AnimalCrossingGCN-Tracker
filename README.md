AnimalCrossingGCN-Tracker - Project Document

Version: v1.10.11.24.a
Release Date: October 11, 2024
Author: Brock Jenkinson

Project Overview

The AnimalCrossingGCN-Tracker is a companion app designed for players of the original Animal Crossing on the GameCube. The app helps players track their museum collectibles, including fossils, bugs, fish, and art. Built with Swift and SwiftUI, it uses SwiftData to ensure data is persistent across iPhone, iPad, and macOS devices, making it a versatile tool for players who want to manage their collections across platforms.

Version v1.10.11.24.a introduces a significant update, adding art tracking functionality. This marks the completion of the four primary collectible categories, enabling players to track fossils, bugs, fish, and now art, bringing the app closer to fulfilling its role as a comprehensive museum tracker.

File Structure

The main view, managed by ContentView.swift, displays fossils, bugs, fish, and art, adapting layouts for different devices like iPhones, iPads, and macOS systems using NavigationStack and NavigationSplitView. It includes a search bar that allows users to search for specific collectibles by name, making it easier to manage large collections. Users can toggle donation statuses and view detailed information for each collectible.

The Fossil.swift file defines the Fossil data model, which includes the fossil’s name, optional part information, and donation status. It is pre-populated with the 25 fossils available in Animal Crossing for GameCube.

The Bug.swift file defines the Bug data model, containing the bug’s name, season availability, and donation status. The app comes pre-populated with a list of 40 bugs, with the bug season display fixed in a previous update to ensure proper formatting.

The Fish.swift file defines the Fish data model, including the fish’s name, season availability, location (river, sea, or pond), and donation status. The app is pre-populated with 40 fish.

The new Art.swift file defines the Art data model. Each art piece includes its name, real-world counterpart, and donation status. This addition pre-populates the app with 13 art pieces from the North American version of Animal Crossing, including famous paintings such as the Mona Lisa (Famous Painting) and Sunflowers (Flowery Painting).

The entry point for the app is AnimalCrossingGCN_TrackerApp.swift, which manages the app’s lifecycle and initializes the SwiftData model container. This ensures that all sections load properly and user data is preserved across sessions.

Unit and UI tests are handled by AnimalCrossingGCN_TrackerTests.swift and AnimalCrossingGCN_TrackerUITests.swift, ensuring that all functionalities work correctly and the user interface remains smooth and responsive.

Current Features

The app now supports full tracking of fossils, bugs, fish, and art. Each section comes pre-populated with the respective items from the game, and users can toggle donation statuses as well as view detailed information on each item. The app uses SwiftData to store user data, so donation statuses are saved between sessions. The search functionality provides a quick way for users to find specific items by name, making it easier to navigate through their collections.

The latest addition of art tracking completes the four main museum sections. Users can now track the 13 art pieces featured in the North American version of Animal Crossing for GameCube. Each art piece comes with information about its in-game name and the real-world artwork it is based on.

The app’s user interface adapts to different devices, utilizing NavigationStack for iPhones and NavigationSplitView for iPads and macOS devices, providing a seamless experience across platforms.

Issues & Limitations

The app currently does not support the deletion of items from the collections. A future update will either introduce a feature allowing users to add or remove items or remove the delete option altogether. The DetailView for each section is functional but still under active development to ensure a smooth experience across all devices.

Future Steps

With the addition of art tracking, the app now covers all four major museum sections: fossils, bugs, fish, and art. The next phase will focus on polishing the user experience and introducing new features. Planned updates include data visualization, which will allow users to track their donation progress through graphs and visual representations. The ability to toggle between fossils, bugs, fish, and art on the graph will give users a more interactive way to track their museum collections. Future updates will also introduce filtering options for sorting items by donation status, season availability, and collectible type.

Another planned feature is data import and export, allowing users to back up their collection data and transfer it between devices. Localization options will also be explored to support multiple languages, making the app more accessible to non-English-speaking players.  I am also going to begin brainstorming names for this app, as I think it may be ready for the app store within the next 1-2 months. Something along the lines of “A Museum Tracker for Animal Crossing”. But that may be limiting the app’s scope, so I’ll continue to think about it.

Cross-Platform Support

The app is designed for seamless use on iPhones, iPads, and macOS devices. SwiftData ensures that collectible data is saved and loaded consistently across these platforms, allowing users to track their collections effortlessly, regardless of the device they are using.

Summary

Version v1.10.11.24.a marks a significant milestone in the development of the AnimalCrossingGCN-Tracker app. With the completion of art tracking, the app now provides a comprehensive tool for managing museum collectibles in Animal Crossing for GameCube. The focus will now shift to refining the app’s usability and introducing new features like data visualization and filtering options, making the app an even more powerful tool for players.
