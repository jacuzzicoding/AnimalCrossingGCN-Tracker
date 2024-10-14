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
=======
Version: v1.10.07.24.a
Release Date: October 7, 2024

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
