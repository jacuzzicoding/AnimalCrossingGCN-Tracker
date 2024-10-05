Animal Crossing App V1

AnimalCrossingGCN-Tracker Development Document

Project Overview:

This is a little passion project for me. It’s a tracking app designed to function as a “second screen experience” for the original Animal Crossing GameCube game. The initial version will focus on tracking museum items, with future updates planned to expand functionality.

The app is built using Swift (SwiftUI) and SwiftData.

File Structure:

The main file structure consists of several Swift files. ContentView.swift is the main view that displays a list of tracked items, such as fossils, bugs, fish, and art. It utilizes @Query to fetch items and implements NavigationSplitView for smooth navigation.

Item.swift is the model representing individual items. It stores information such as item type (fossil, bug, fish, art), timestamps, and other relevant metadata.

AnimalCrossingGCN_TrackerApp.swift serves as the entry point of the app and manages the app lifecycle.

The project also contains test files, including AnimalCrossingGCN_TrackerTests.swift for unit tests and AnimalCrossingGCN_TrackerUITests.swift for UI tests.

Features (Current and Planned):

The initial version will focus on museum item tracking. The app will allow users to track four types of museum items: fossils, bugs, fish, and art. The items will be displayed in categorized lists with details such as collection dates and species.

The app will use NavigationSplitView to navigate between different item categories, ensuring easy access to each type of museum item.

SwiftData will be used to persist data, ensuring the tracked items are saved and available even after the app is closed.

For future versions, the app will expand to include town customization, villager tracking, and progress tracking. These features will allow users to name their town, add villagers, and monitor progress like Nook store upgrades and holidays.

Tasks:

The first step is to implement the functionality to create, edit, and delete museum items for the four categories: fossils, bugs, fish, and art. The item categories must be organized properly within ContentView.swift.

Next, SwiftData will be set up to ensure data persistence for each museum item category, making sure the data is saved reliably.

The user interface and experience will need enhancements to ensure smooth navigation and interaction. This will include adding detailed views for each item category, providing more information about the tracked items.

Lastly, unit tests and UI tests will be written and implemented to ensure the app functions as expected and interactions are smooth.

Next Steps:

For October 5, 2024, the priority is to finalize the data structure for the four museum item categories. The development of the user interface to display and manage these items will follow. Writing and implementing unit tests, as well as testing data persistence using SwiftData, are key tasks to be completed.

Notes:

Future expansions will require reworking parts of the data model to accommodate the increased complexity of adding town customization, villager tracking, and other game-related features.
