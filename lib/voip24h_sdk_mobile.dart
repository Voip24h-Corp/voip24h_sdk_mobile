import 'dart:async';
import 'package:flutter/services.dart';
import 'package:voip24h_sdk_mobile/callkit/call_module.dart';
import 'package:voip24h_sdk_mobile/graph/graph_module.dart';

class Voip24hSdkMobile {

  static const MethodChannel _channel = MethodChannel('flutter_voip24h_sdk_mobile_method_channel');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static GraphModule graphModule = GraphModule.instance;
  static CallModule callModule = CallModule.instance;
}
