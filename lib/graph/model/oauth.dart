class Oauth {

  final String _token;
  final String _createAt;
  final String _expired;
  final bool _isLongLive;

  Oauth({
    required String token,
    required String createAt,
    required String expired,
    required bool isLongLive
  }) : _token = token, _createAt = createAt, _expired = expired, _isLongLive = isLongLive;

  String get token => _token;

  String get createAt => _createAt;

  String get expired => _expired;

  bool get isLongLive => _isLongLive;
}