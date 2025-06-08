import 'package:flutter_test/flutter_test.dart';
import 'package:fused_location/fused_location.dart';
import 'package:fused_location/fused_location_platform_interface.dart';
import 'package:fused_location/fused_location_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFusedLocationPlatform
    with MockPlatformInterfaceMixin
    implements FusedLocationPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FusedLocationPlatform initialPlatform = FusedLocationPlatform.instance;

  test('$MethodChannelFusedLocation is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFusedLocation>());
  });

  test('getPlatformVersion', () async {
    FusedLocation fusedLocationPlugin = FusedLocation();
    MockFusedLocationPlatform fakePlatform = MockFusedLocationPlatform();
    FusedLocationPlatform.instance = fakePlatform;

    expect(await fusedLocationPlugin.getPlatformVersion(), '42');
  });
}
