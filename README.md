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
---


## 🌐 Enabling Google Map SDK for Each Platform

To use Google Maps in your Flutter application, you need to enable the **Google Map SDK** for both Android and iOS platforms. Follow the steps below to set it up.

### Step 1: Access Google Developers Console

1. Go to the [Google Developers Console](https://console.cloud.google.com/).
2. Sign in with your Google account if required.

### Step 2: Choose Your Project

1. Choose the project where you want to enable Google Maps.
2. If you don't have a project, create a new one by clicking on **Select a Project** → **New Project**.

### Step 3: Enable Google Maps SDK

#### 🛠️ For Android

1. In the **navigation menu**, go to **Google Maps**.
2. Click on **APIs** under the Google Maps menu.
3. In the **Additional APIs** section, find **Maps SDK for Android**.
4. Click on it, then select **ENABLE**.

#### 🛠️ For iOS

1. In the **navigation menu**, go to **Google Maps**.
2. Click on **APIs** under the Google Maps menu.
3. In the **Additional APIs** section, find **Maps SDK for iOS**.
4. Click on it, then select **ENABLE**.

#### 🛠️ For Web (Optional)

1. If you plan to use the app on the web, enable the **Maps JavaScript API**.
2. In the **navigation menu**, go to **Google Maps**.
3. Click on **APIs** under the Google Maps menu.
4. In the **Additional APIs** section, find **Maps JavaScript API**.
5. Click on it, then select **ENABLE**.

### Step 4: Verify Enabled APIs

- Make sure the APIs you have enabled are listed under the **Enabled APIs** section in the **Google Developers Console**.

### Step 5: Obtain API Key

1. Go to **APIs & Services** → **Credentials**.
2. Click on **Create credentials** → **API key**.
3. Copy the generated API key.

### Step 6: Add API Key to Your Flutter Project

In your Flutter project, add the API key to the `AndroidManifest.xml` and `Info.plist` files.

#### For Android (`AndroidManifest.xml`):

```xml
<manifest>
    <application>
        <!-- Add your Google Maps API Key here -->
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_API_KEY_HERE"/>
    </application>
</manifest>

## ⚙️ Permissions Setup
---
## For Android:
   **In AndroidMenifest.xml add permissions**:

   ```yaml
         <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
         <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
   ```

## For IOS:
   **In Info.plist add permissions**:

   ```yaml
         <key>NSLocationWhenInUseUsageDescription</key>
         <string>We require your location to display your current position on the map.</string>
         <key>NSLocationAlwaysUsageDescription</key>
         <string>We require continuous location access to track your movements.</string>
         <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
         <string>We require location access at all times to provide accurate tracking.</string>
   ```

