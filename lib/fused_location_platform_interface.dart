import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fused_location_method_channel.dart';

abstract class FusedLocationPlatform extends PlatformInterface {
  /// Constructs a FusedLocationPlatform.
  FusedLocationPlatform() : super(token: _token);

  static final Object _token = Object();

  static FusedLocationPlatform _instance = MethodChannelFusedLocation();

  /// The default instance of [FusedLocationPlatform] to use.
  ///
  /// Defaults to [MethodChannelFusedLocation].
  static FusedLocationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FusedLocationPlatform] when
  /// they register themselves.
  static set instance(FusedLocationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
