// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:voip24h_sdk_mobile/voip24h_sdk_mobile_method_channel.dart';
//
// void main() {
//   MethodChannelVoip24hSdkMobile platform = MethodChannelVoip24hSdkMobile();
//   const MethodChannel channel = MethodChannel('voip24h_sdk_mobile');
//
//   TestWidgetsFlutterBinding.ensureInitialized();
//
//   setUp(() {
//     channel.setMockMethodCallHandler((MethodCall methodCall) async {
//       return '42';
//     });
//   });
//
//   tearDown(() {
//     channel.setMockMethodCallHandler(null);
//   });
//
//   test('getPlatformVersion', () async {
//     expect(await platform.getPlatformVersion(), '42');
//   });
// }
