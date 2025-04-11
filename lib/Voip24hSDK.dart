import 'dart:async';

import 'package:flutter/services.dart';
import 'package:voip24h_sdk_mobile/PushNotificationModule.dart';
import 'package:voip24h_sdk_mobile/call/CallModule.dart';
import 'package:voip24h_sdk_mobile/graph/GraphModule.dart';

class Voip24hSDK {
  static const MethodChannel _channel = MethodChannel('flutter_voip24h_sdk_mobile_method_channel');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static GraphModule graphModule = GraphModule.instance;
  static CallModule callModule = CallModule.instance;
  static PushNotificationModule pushNotificationModule = PushNotificationModule.instance;
}
