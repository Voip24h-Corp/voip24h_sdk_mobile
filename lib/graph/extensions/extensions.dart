extension JsonObjectToObject on Map<String, dynamic> {

  Object? getData() {
    if(isEmpty) {
      return null;
    }
    var data = this['data']['response']['data'];
    if(data is List<dynamic> || data == null) {
      return null;
    }
    if((data as Map<String, dynamic>).containsKey('data')) {
      data = data['data'];
    }
    return data;
  }

  List<dynamic>? getDataList() {
    if(isEmpty) {
      return null;
    }
    var data = this['data']['response']['data'];
    if(data is! List<dynamic> || data == null) {
      return null;
    }
    return data;
  }

  int statusCode() {
    if(isEmpty) {
      return -1;
    }
    var error = this['error'];
    if(error != null) {
      return error['code'];
    }
    var data = this['data']['response']['status'];
    return data;
  }

  String message() {
    if(isEmpty) {
      return 'Not message';
    }
    var error = this['error'];
    if(error != null) {
      return error['message'];
    }
    var data = this['data']['response']['message'];
    return data;
  }

  int limit() {
    try {
      var data = this['data']['response']['meta']['limit'];
      return data;
    } catch(exception) {
      return -1;
    }
  }

  int offset() {
    try {
      var data = this['data']['response']['meta']['offset'];
      return data;
    } catch(exception) {
      return -1;
    }
  }

  int total() {
    try {
      var data = this['data']['response']['meta']['total'];
      return data;
    } catch(exception) {
      return -1;
    }
  }

  String isSort() {
    try {
      var data = this['data']['response']['meta']['sort'];
      return data;
    } catch(exception) {
      return "Sort not found";
    }
  }
}