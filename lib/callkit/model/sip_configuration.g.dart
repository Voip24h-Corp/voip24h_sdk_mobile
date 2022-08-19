// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SipConfiguration _$SipConfigurationFromJson(Map<String, dynamic> json) =>
    SipConfiguration(
      json['extension'] as String,
      json['domain'] as String,
      json['password'] as String,
      json['port'] as int,
      $enumDecode(_$TransportTypeEnumMap, json['transportType']),
      json['isKeepAlive'] as bool,
    );

Map<String, dynamic> _$SipConfigurationToJson(SipConfiguration instance) =>
    <String, dynamic>{
      'extension': instance.extension,
      'domain': instance.domain,
      'password': instance.password,
      'port': instance.port,
      'transportType': _$TransportTypeEnumMap[instance.transportType]!,
      'isKeepAlive': instance.isKeepAlive,
    };

const _$TransportTypeEnumMap = {
  TransportType.Tcp: 'Tcp',
  TransportType.Udp: 'Udp',
  TransportType.Tls: 'Tls',
};
