// import 'package:flutter_test/flutter_test.dart';
// import 'package:voip24h_sdk_mobile/voip24h_sdk_mobile.dart';
// import 'package:voip24h_sdk_mobile/voip24h_sdk_mobile_platform_interface.dart';
// import 'package:voip24h_sdk_mobile/voip24h_sdk_mobile_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockVoip24hSdkMobilePlatform
//     with MockPlatformInterfaceMixin
//     implements Voip24hSdkMobilePlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final Voip24hSdkMobilePlatform initialPlatform = Voip24hSdkMobilePlatform.instance;
//
//   test('$MethodChannelVoip24hSdkMobile is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelVoip24hSdkMobile>());
//   });
//
//   test('getPlatformVersion', () async {
//     Voip24hSdkMobile voip24hSdkMobilePlugin = Voip24hSdkMobile();
//     MockVoip24hSdkMobilePlatform fakePlatform = MockVoip24hSdkMobilePlatform();
//     Voip24hSdkMobilePlatform.instance = fakePlatform;
//
//     expect(await voip24hSdkMobilePlugin.getPlatformVersion(), '42');
//   });
// }
