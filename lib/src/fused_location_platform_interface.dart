import "package:fused_location/fused_location_options.dart";
import "package:fused_location/fused_location.dart";
import "package:plugin_platform_interface/plugin_platform_interface.dart";

import "fused_location_method_channel.dart";

abstract class FusedLocationPlatformInterface extends PlatformInterface {
  FusedLocationPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static FusedLocationPlatformInterface _instance =
      FusedLocationMethodChannel();

  /// The default instance of [FusedLocationPlatformInterface] to use.
  ///
  /// Defaults to [FusedLocationMethodChannel].
  static FusedLocationPlatformInterface get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FusedLocationPlatformInterface] when
  /// they register themselves.
  static set instance(FusedLocationPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<FusedLocation> get dataStream {
    throw UnimplementedError(
      "dataStream has not been implemented.",
    );
  }

  Future<void> startLocationUpdates({
    required FusedLocationProviderOptions options,
  }) {
    throw UnimplementedError(
      "startLocationUpdates() has not been implemented.",
    );
  }

  Future<void> stopLocationUpdates() {
    throw UnimplementedError(
      "stopLocationUpdates() has not been implemented.",
    );
  }
}
