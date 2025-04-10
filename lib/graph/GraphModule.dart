import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:voip24h_sdk_mobile/extensions/Extensions.dart';
import 'package:voip24h_sdk_mobile/models/OAuth.dart';
import 'package:voip24h_sdk_mobile/utils/GraphRoute.dart';

class GraphModule {
  GraphModule._privateConstructor();

  static final GraphModule _instance = GraphModule._privateConstructor();

  static GraphModule get instance => _instance;

  static final _URL_GRAPH = "https://api.voip24h.vn/v3";

  Future<OAuth> getAccessToken({required String apiKey, required String apiSecret}) async {
    try {
      var uri = Uri.parse('$_URL_GRAPH/authentication');
      var response = await http.post(uri, body: {'apiKey': apiKey, 'apiSecret': apiSecret}).timeout(const Duration(seconds: 10));
      var data = json.decode(response.body);
      if (data == null || response.statusCode != 200 || data['error'] != null) {
        print(data);
        return Future.value(OAuth(token: "", createAt: "", expired: "", isLongLive: false));
      }
      var token = data['data']['token'];
      var createAt = data['data']['createAt'];
      var expired = data['data']['expired'];
      var isLongLive = data['data']['isLongLive'];
      return Future.value(OAuth(token: token, createAt: createAt, expired: expired, isLongLive: isLongLive));
    } catch (exception) {
      return Future.error(exception);
    }
  }

  Future<Map<String, dynamic>> sendRequest({required String token, required GraphRoute route, Map<String, dynamic>? params}) async {
    try {
      var uri = Uri.parse('$_URL_GRAPH/${route.value}');
      var response = await route.request(uri, headers: {'Authorization': 'Bearer $token'}, params);
      var data = json.decode(response.body);
      if (data == null || response.statusCode != 200 || data['error'] != null) {
        print(data);
        return Future.value({});
      }
      return Future.value(data);
    } catch (exception) {
      return Future.error(exception);
    }
  }

// bool _isStatusCodeSuccess(dynamic data) {
//   // return ((data['data']['response']['status'] is int) && data['data']['response']['status'] != 1000) ||
//   //     (data['data']['response']['status'] is String) && data['data']['response']['status'] != '1000';
//   return ((data['data']['status'] is int) && data['data']['status'] != 1000) ||
//       (data['data']['status'] is String) && data['data']['status'] != '1000';
// }
}
