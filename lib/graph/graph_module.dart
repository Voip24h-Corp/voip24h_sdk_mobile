import 'dart:convert';
import 'package:voip24h_sdk_mobile/graph/model/oauth.dart';
import 'package:http/http.dart' as http;

class GraphModule {

  GraphModule._privateConstructor();

  static final GraphModule _instance = GraphModule._privateConstructor();

  static GraphModule get instance => _instance;

  static const _URL_OAUTH = "http://auth2.voip24h.vn/api/token";

  static const _URL_GRAPH = "http://graph.voip24h.vn/";

  Future<Oauth> getAccessToken({required String apiKey, required String apiSecert}) async {
    try {
      var uri = Uri.parse(_URL_OAUTH);
      var response = await http.post(uri, body: {'api_key': apiKey, 'api_secert': apiSecert}).timeout(const Duration(seconds: 10));
      var data = json.decode(response.body);
      if (data == null || data['error'] != null || response.statusCode != 200 || _isStatusCodeSuccess(data)) {
        print(data);
        return Future.value(Oauth(token: "", createAt: "", expired: "", isLongLive: false));
      }
      var token = data['data']['response']['data']['IsToken'];
      var createAt = data['data']['response']['data']['Createat'];
      var expired = data['data']['response']['data']['Expried'];
      var isLongLive = data['data']['response']['data']['IsLonglive'];
      return Future.value(Oauth(token: token, createAt: createAt, expired: expired, isLongLive: isLongLive));
    } catch (exception) {
      return Future.error(exception);
    }
  }

  Future<Map<String, dynamic>> sendRequest({required String token, required String endpoint, required Object body}) async {
    try {
      var uri = Uri.parse(_URL_GRAPH + endpoint);
      var response = await http.post(uri, headers: {
        'Authorization': 'Bearer $token'
      }, body: body);
      var data = json.decode(response.body);
      if (data == null || data['error'] != null || response.statusCode != 200 || _isStatusCodeSuccess(data)) {
        print(data);
        return Future.value({});
      }
      return Future.value(data);
    } catch (exception) {
      return Future.error(exception);
    }
  }

  bool _isStatusCodeSuccess(dynamic data) {
    return ((data['data']['response']['status'] is int) && data['data']['response']['status'] != 1000) ||
        (data['data']['response']['status'] is String) && data['data']['response']['status'] != '1000';
  }
}