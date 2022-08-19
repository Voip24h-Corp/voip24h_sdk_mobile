import 'dart:core';
import 'package:voip24h_sdk_mobile/callkit/utils/transport_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sip_configuration.g.dart';

@JsonSerializable()
class SipConfiguration {
  @JsonKey(name: "extension")
  final String _ext;
  @JsonKey(name: "domain")
  final String _domain;
  @JsonKey(name: "password")
  final String _password;
  @JsonKey(name: "port")
  int _port = 5060;
  @JsonKey(name: "transportType")
  TransportType _transportType = TransportType.Udp;
  @JsonKey(name: "isKeepAlive")
  bool _isKeepAlive = false;

  SipConfiguration(String extension, String domain, String password, int port, TransportType transportType, bool isKeepAlive)
      : _ext = extension,
        _domain = domain,
        _password = password,
        _port = port,
        _transportType = transportType,
        _isKeepAlive = isKeepAlive;

  SipConfiguration._builder(SipConfigurationBuilder builder)
      : _ext = builder._ext,
        _domain = builder._domain,
        _password = builder._password,
        _port = builder._port,
        _transportType = builder._transportType,
        _isKeepAlive = builder._isKeepAlive;

  String get extension => _ext;

  String get domain => _domain;

  String get password => _password;

  int get port => _port;

  TransportType get transportType => _transportType;

  bool get isKeepAlive => _isKeepAlive;

  factory SipConfiguration.fromJson(Map<String, dynamic> json) => _$SipConfigurationFromJson(json);

  /// Connect the generated [_$SipConfigurationToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SipConfigurationToJson(this);
}

class SipConfigurationBuilder {
  final String _ext;
  final String _domain;
  final String _password;
  int _port = 5060;
  TransportType _transportType = TransportType.Udp;
  bool _isKeepAlive = false;

  SipConfigurationBuilder({required String extension, required String domain, required String password})
      : _ext = extension,
        _domain = domain,
        _password = password;

  SipConfigurationBuilder setPort(int port) {
    _port = port;
    return this;
  }

  SipConfigurationBuilder setTransport(TransportType transportType) {
    _transportType = transportType;
    return this;
  }

  SipConfigurationBuilder setKeepAlive(bool isKeepAlive) {
    _isKeepAlive = isKeepAlive;
    return this;
  }

  SipConfiguration build() {
    return SipConfiguration._builder(this);
  }
}
