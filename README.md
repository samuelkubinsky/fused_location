# 📍 Fused Location

This package designed to give you rich, detailed information about your device's position and movement. We focus on delivering location data, letting other tools handle permissions.

## ✨ Why Choose This Plugin?

* 📡 **Super Accurate Data:** Whether you're on Android or iOS, we tap into the most advanced sensors to give you precise location, elevation, speed, and direction.
    * **Android's Advanced Approach:** On Android, this plugin leverages the `FusedLocationProviderClient` with `Priority.PRIORITY_HIGH_ACCURACY` for optimal geospatial positioning, and **critically**, integrates the new `FusedOrientationProviderClient`. [Introduced in 2024](https://android-developers.googleblog.com/2024/03/introducing-fused-orientation-provider-api.html) via Google Play Services, this new orientation provider is a **significant enhancement** over the traditional Rotation Vector, providing unified, high-performance device orientation by fusing accelerometer, gyroscope, and magnetometer data. This API ensures consistent behavior across diverse hardware, incorporates local magnetic declination, and automatically compensates for sensor variances, leading to a more stable and accurate heading.
    * **iOS's Precision:** For iOS, the plugin employs `CoreLocation` configured with desired accuracy `kCLLocationAccuracyBestForNavigation`. This highly specific accuracy setting instructs the system to deliver the most precise location data possible, making it the gold standard for demanding navigation and real-time tracking applications.
* 📦 **All Your Data in One Place:** You get all the location and motion information you need neatly bundled into a single, easy-to-use stream.
* 🔋 **Smart & Efficient Updates:** We've optimized how updates are delivered. For instance, on Android, your device's orientation data won't constantly refresh if it hasn't changed much. This means smoother map experiences and better battery life for your users!
* 🔄 **Customizable Updates:** You can set how far your device needs to move before you get a new location update. This helps you balance accuracy with efficiency.
* 🗺️ **Perfect for Navigation:** If you're building an app that needs highly accurate and constant location updates – like a navigation app using [flutter_map](https://pub.dev/packages/flutter_map) – this plugin is an ideal choice.
* 📱 **Wide Device Support:** Works seamlessly on a broad range of devices, from iOS 12.0 / Android 5.0 and newer.

## ✋ Important: Permissions

This plugin is all about getting location data, not managing permissions. For handling permissions, we highly recommend using the popular `permission_handler` package. You'll need to ask your users for location access (like "while in use" or "always") to make this plugin work.

## 📊 What Data You Get

Our plugin provides a rich `FusedLocation` object with detailed information:

* **Position:** Your latitude, longitude, and how accurate that position is.
* **Elevation:** Your altitude above sea level and the WGS84 ellipsoid, with accuracy estimates for both.
* **Course:** The direction your device is currently moving and its accuracy.
* **Speed:** Your current speed and its accuracy.
* **Heading:** The direction your device is pointing (relative to true north) and its accuracy.
* **Timestamp:** When the data was recorded.

## ⚠️ Understanding Data Availability

* Not all data fields are available at all times.
* This can be due to hardware capabilities of the device, the operating system version, or even the current state of the device (e.g., if the user is stationary, speed and course information might not be provided).
* If a piece of information isn't available, the corresponding field in the `FusedLocation` object will simply be `null`.
* The table below details when you can expect specific data points based on the operating system.

| Field                            | Android API | iOS Version |
| :------------------------------- | :---------- | :---------- |
| `position.latitude`              | ✅ 21+      | ✅ 12.0+     |
| `position.longitude`             | ✅ 21+      | ✅ 12.0+     |
| `position.accuracy`              | ✅ 21+      | ✅ 12.0+     |
| `elevation.meanSeaLevel`         | ⚠️ 34+      | ✅ 12.0+     |
| `elevation.meanSeaLevelAccuracy` | ⚠️ 34+      | ✅ 12.0+     |
| `elevation.ellipsoidal`          | ✅ 21+      | ⚠️ 15.0+     |
| `elevation.ellipsoidalAccuracy`  | ⚠️ 26+      | ⚠️ 15.0+     |
| `course.direction`               | ✅ 21+      | ⚠️ 13.4+     |
| `course.accuracy`                | ⚠️ 26+      | ⚠️ 13.4+     |
| `speed.magnitude`                | ✅ 21+      | ✅ 12.0+     |
| `speed.accuracy`                 | ⚠️ 26+      | ✅ 12.0+     |
| `heading.direction`              | ✅ 21+      | ✅ 12.0+     |
| `heading.accuracy`               | ✅ 21+      | ✅ 12.0+     |

## 🚀 Basic Usage

Here's a simplified example of how you might implement a repository:

```dart
class LocationRepository {
  final _service = FusedLocationProvider();

  /// Provides a stream of continuous FusedLocation updates.
  Stream<FusedLocation> get dataStream {
    return _service.dataStream;
  }

  /// Starts the location update process with configurable options.
  /// Ensure permissions are granted before calling this.
  Future<void> startLocationUpdates() {
    const options = FusedLocationProviderOptions(distanceFilter: 5);
    return _service.startLocationUpdates(options: options);
  }

  /// Stops the location update process, saving battery.
  Future<void> stopLocationUpdates() {
    return _service.stopLocationUpdates();
  }
}
```

For a complete and runnable example, please refer to the `example/` folder within this repository. To run it:

```bash
cd example/
flutter pub get
flutter pub run build_runner build
flutter run
```
