# 📍 User Tracking App

The **User Tracking App** is a mobile application built with Flutter that allows users to track their real-time location on a Google Map, with options to start and stop tracking. The app draws a polyline representing the user's movement when tracking is enabled. This is especially useful for fitness tracking, delivery services, or location-based logging.

---

## 📱 Features

1. **My Location Button**:
   - A **My Location** icon button is available to instantly focus the map on the user's current location.

2. **Start Tracking**:
   - When the user clicks the **Start Tracking** button, the app begins tracking their location in real-time.
   - A polyline is drawn on the map, showing the path as the user moves.

3. **Stop Tracking**:
   - Clicking **Stop Tracking** pauses the tracking of the user's location.
   - The existing polyline remains visible on the map until a new session begins.

4. **Restart Tracking**:
   - If the user clicks **Start Tracking** again after stopping, the previous polyline is cleared.
   - A new polyline starts to draw from the user's current location.

---

## 🔧 Tech Stack

- **Framework**: Flutter
- **Programming Language**: Dart
- **Mapping Service**: Google Maps API

---

## 🛠️ Dependencies

Make sure to include the following dependencies in your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  location: ^5.1.0
  google_maps_flutter: ^2.2.0
```
