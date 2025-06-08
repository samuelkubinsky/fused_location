import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fused_location_platform_interface.dart';

/// An implementation of [FusedLocationPlatform] that uses method channels.
class MethodChannelFusedLocation extends FusedLocationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fused_location');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
