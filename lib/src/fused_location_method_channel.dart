import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:fused_location/fused_location.dart";
import "package:fused_location/fused_location_options.dart";

import "fused_location_platform_interface.dart";

/// An implementation of [FusedLocationPlatformInterface] that uses method channels.
class FusedLocationMethodChannel extends FusedLocationPlatformInterface {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel("fused_location");

  @visibleForTesting
  final eventChannel = const EventChannel("fused_location/stream");

  Stream<FusedLocation>? _dataStream;

  @override
  Stream<FusedLocation> get dataStream {
    _dataStream ??= eventChannel.receiveBroadcastStream().map(parseNativeStreamData);
    return _dataStream!;
  }

  @override
  Future<void> startLocationUpdates({required FusedLocationProviderOptions options}) {
    return methodChannel.invokeMethod<void>("startLocationUpdates", options.toJson());
  }

  @override
  Future<void> stopLocationUpdates() {
    return methodChannel.invokeMethod<void>("stopLocationUpdates");
  }

  FusedLocation parseNativeStreamData(dynamic data) {
    if (data is! Map) {
      throw ArgumentError("Expected map, got ${data.runtimeType}");
    }
    final map = data.cast<String, double>();
    return FusedLocation.fromJson(map);
  }
}
