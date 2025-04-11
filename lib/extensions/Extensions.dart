import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:voip24h_sdk_mobile/utils/GraphRoute.dart';

extension JsonObjectToObject on Map<String, dynamic> {
  Object? getData() {
    if (isEmpty) {
      return null;
    }
    var data = this['data'];
    print(data);
    if (data is List<dynamic> || data == null) {
      return null;
    }
    // if((data as Map<String, dynamic>).containsKey('data')) {
    //   data = data['data'];
    // }
    return data;
  }

  List<dynamic>? getDataList() {
    if (isEmpty) {
      return null;
    }
    var data = this['data'];
    print(data);
    if (data is! List<dynamic>) {
      return null;
    }
    return data;
  }

  int statusCode() {
    if (isEmpty) {
      return -1;
    }
    var error = this['error'];
    if (error != null) {
      return error['code'];
    }
    var data = this['status'];
    return data;
  }

  String message() {
    if (isEmpty) {
      return 'Not message';
    }
    var error = this['error'];
    if (error != null) {
      return error['message'];
    }
    var data = this['message'];
    return data;
  }

  int limit() {
    try {
      var data = this['limit'];
      return data;
    } catch (exception) {
      return -1;
    }
  }

  int offset() {
    try {
      var data = this['offset'];
      return data;
    } catch (exception) {
      return -1;
    }
  }

  int total() {
    try {
      var data = this['totalData'];
      return data;
    } catch (exception) {
      return -1;
    }
  }

// String isSort() {
//   try {
//     var data = this['data']['response']['meta']['sort'];
//     return data;
//   } catch(exception) {
//     return "Sort not found";
//   }
// }
}

extension RouteRequest on GraphRoute {
  Future<Response> request(Uri uri, Map<String, dynamic>? params, {required Map<String, String> headers}) {
    switch (this) {
      case GraphRoute.CallLog:
      case GraphRoute.Record:
      case GraphRoute.Contact:
        var uriQuery = params != null ? Uri.parse(uri.toString()).replace(queryParameters: params) : uri;
        return http.get(uriQuery, headers: headers);
      case GraphRoute.AddContact:
        return http.post(uri, headers: headers, body: params);
      case GraphRoute.UpdateContact:
        return http.put(uri, headers: headers, body: params);
      case GraphRoute.DeleteContact:
        return http.delete(uri, headers: headers, body: params);
    }
  }
}
