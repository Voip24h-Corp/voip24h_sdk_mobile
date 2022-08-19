import 'package:json_annotation/json_annotation.dart';

enum TransportType {
  @JsonValue('Tcp')
  Tcp,
  @JsonValue('Udp')
  Udp,
  @JsonValue('Tls')
  Tls
}