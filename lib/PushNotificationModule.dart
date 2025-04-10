import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:voip24h_sdk_mobile/models/SipConfiguration.dart';

class PushNotificationModule {
  PushNotificationModule._privateConstructor();

  static final PushNotificationModule _instance = PushNotificationModule._privateConstructor();

  static PushNotificationModule get instance => _instance;

  static const _URL_REGISTER_PUSH_NOTIFICATION = "http://14.225.251.99:1998/register_push_for_sdk";
  static const _URL_UNREGISTER_PUSH_NOTIFICATION = "http://14.225.251.99:1998/unregister_push_for_sdk";

  Future<dynamic> registerPushNotification(
      {required String tokenGraph,
      required String token,
      required SipConfiguration sipConfiguration,
      bool isAndroid = false,
      bool isIOS = false,
      required String appId,
      required bool isProduction,
      required String deviceMac}) async {
    try {
      var platform = isAndroid
          ? "android"
          : isIOS
              ? "ios"
              : "unknown";
      var env = isProduction ? "prod" : "dev";
      if (platform != "unknown") {
        var uri = Uri.parse(_URL_REGISTER_PUSH_NOTIFICATION);
        var response = await http.post(uri, headers: {
          'Authorization': 'Bearer $tokenGraph'
        }, body: {
          'pbx_ip': sipConfiguration.domain,
          'extension': sipConfiguration.extension,
          'device_os': platform,
          'device_mac': deviceMac,
          'voip_token': token,
          'env': env,
          'app_id': appId,
          'is_new': '1',
          'is_active': '1',
          'transport': 'udp'
        }).timeout(const Duration(seconds: 10));
        var data = json.decode(response.body);
        return Future.value(data);
      } else {
        return Future.error("Can't found Platform");
      }
    } catch (exception) {
      return Future.error(exception);
    }
  }

  Future<dynamic> unregisterPushNotification(
      {required SipConfiguration sipConfiguration, bool isAndroid = false, bool isIOS = false, required String appId}) async {
    try {
      var platform = isAndroid
          ? "android"
          : isIOS
              ? "ios"
              : "unknown";
      if (platform != "unknown") {
        var uri = Uri.parse(_URL_UNREGISTER_PUSH_NOTIFICATION);
        var response = await http.post(uri, body: {
          'pbx_ip': sipConfiguration.domain,
          'extension': sipConfiguration.extension,
          'device_os': platform,
          'app_id': appId
        }).timeout(const Duration(seconds: 10));
        var data = json.decode(response.body);
        return Future.value(data);
      } else {
        return Future.error("Can't found Platform");
      }
    } catch (exception) {
      return Future.error(exception);
    }
  }
}
