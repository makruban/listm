# Main App Idea: TripWise

TripWise is a Flutter application designed to help users organize and remember essential items when preparing for trips.

---

## Main goals:
- Allow users to add and manage personal items (e.g., hat, pants, socks).
- Provide two main types of lists:
  - **All Items** — a catalog of all saved items.
  - **Packing Lists** — specific lists for individual trips (e.g., "Lake Trip", "Picnic Trip").
- Allow users to create multiple Packing Lists.
- Ensure that adding an item to a Packing List also adds it automatically to All Items if not already present.
- Enable two types of deletion:
  - Remove item from a Packing List only (item stays in All Items and other lists).
  - Remove item from All Items (item is removed from All Items and all Packing Lists).
- Allow users to delete entire Packing Lists.
- Support item selection:
  - Each item should have a checkbox.
  - Selecting an item crosses the text out and changes its color to grayish.
  - Unselecting restores normal appearance.

---

## Technical and UX requirements:
- **State Management:** Use the Bloc package to manage all application state (All Items, Packing Lists, UI interactions).
- **Persistence:** Use SharedPreferences for storing all local data (items, trips, selections).
- **Floating Action Button (FAB) Behavior:**
  - Always present a floating action button for "adding."
  - Behavior depends on the active screen:
    - In **All Items**: FAB opens an input field to create a new item.
    - In **Packing Lists Overview**: FAB opens an input field to create a new trip.
    - Inside a **specific Packing List**: FAB opens an input field to add an item to that trip.
- **Empty State:** 
  - If there are no items or trips, show a clean "empty list" message with a button to add the first entry.
- **Localization:**
  - The app should detect the user's device language and load appropriate localization (e.g., English, Ukrainian, German).
  - Use Flutter’s internationalization support.
- **Platform Adaptation:**
  - At startup, check the platform using:
    ```dart
    Platform.isIOS
      ? const CupertinoAppStructure()
      : const MaterialAppStructure();
    ```
  - Use `MaterialApp` for Android, Windows, Linux, macOS.
  - Use `CupertinoApp` for iOS.

---

## Non-goals:
- No user accounts or authentication flows.
- No remote servers or REST APIs.
- No cloud storage.
- No complex folder synchronization.

---

## Target Platforms:
- Android
- iOS
- (Desktop platforms are optional future targets)

---

## Design style:
- Modern Material 3 design principles (Material You for Android 12+).
- Cupertino Design System on iOS.
- Clean, minimalistic, and user-friendly interface.
- Smooth navigation via BottomNavigationBar.

---

## Performance priorities:
- Local, fast, and offline-first behavior.
- Persistent storage without delays.
- Efficient Bloc-based state management.