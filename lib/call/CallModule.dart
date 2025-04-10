import 'dart:async';

import 'package:flutter/services.dart';
import 'package:voip24h_sdk_mobile/models/SipConfiguration.dart';
import 'package:voip24h_sdk_mobile/utils/CallEvent.dart';
import 'package:voip24h_sdk_mobile/utils/Codecs.dart';

class CallModule {
  CallModule._privateConstructor();

  static final CallModule _instance = CallModule._privateConstructor();

  static CallModule get instance => _instance;

  static const MethodChannel _methodChannel = MethodChannel('flutter_voip24h_sdk_mobile_method_channel');

  static const EventChannel _eventChannel = EventChannel('flutter_voip24h_sdk_mobile_event_channel');

  static Stream broadcastStream = _eventChannel.receiveBroadcastStream();

  // Flutter
  final StreamController<dynamic> _eventStreamController = StreamController.broadcast();

  StreamController<dynamic> get eventStreamController => _eventStreamController;

  Future<void> initSipModule(SipConfiguration sipConfiguration) async {
    if (!_eventStreamController.hasListener) {
      broadcastStream.listen(_listener);
    }
    await _methodChannel.invokeMethod('initSipModule', {"sipConfiguration": sipConfiguration.toJson()});
  }

  void _listener(dynamic event) {
    final eventName = event['event'] as String;
    final callEvent = CallEvent.fromString(eventName);
    _eventStreamController.add({'event': callEvent, 'body': event['body']});
    // switch (eventName) {
    //   case 'AccountRegistrationStateChanged':
    //     _eventStreamController.add({'event': CallEvent.AccountRegistrationStateChanged, 'body': event['body']});
    //     break;
    //   case 'Ring':
    //     _eventStreamController.add({'event': CallEvent.Ring, 'body': event['body']});
    //     break;
    //   case 'Up':
    //     _eventStreamController.add({'event': CallEvent.Up, 'body': event['body']});
    //     break;
    //   case 'Paused':
    //     _eventStreamController.add({'event': CallEvent.Paused});
    //     break;
    //   case 'Resuming':
    //     _eventStreamController.add({'event': CallEvent.Resuming});
    //     break;
    //   case 'Missed':
    //     _eventStreamController.add({'event': CallEvent.Missed, 'body': event['body']});
    //     break;
    //   case 'Hangup':
    //     _eventStreamController.add({'event': CallEvent.Hangup, 'body': event['body']});
    //     break;
    //   case 'Error':
    //     _eventStreamController.add({'event': CallEvent.Error, 'body': event['body']});
    //     break;
    // }
  }

  Future<bool> call(String phoneNumber) async {
    return await _methodChannel.invokeMethod('call', {"recipient": phoneNumber});
  }

  Future<bool> hangup() async {
    return await _methodChannel.invokeMethod('hangup');
  }

  Future<bool> answer() async {
    return await _methodChannel.invokeMethod('answer');
  }

  Future<bool> reject() async {
    return await _methodChannel.invokeMethod('reject');
  }

  Future<bool> transfer(String extension) async {
    return await _methodChannel.invokeMethod('transfer', {"extension": extension});
  }

  Future<bool> pause() async {
    return await _methodChannel.invokeMethod('pause');
  }

  Future<bool> resume() async {
    return await _methodChannel.invokeMethod('resume');
  }

  Future<bool> sendDTMF(String dtmf) async {
    return await _methodChannel.invokeMethod('sendDTMF', {"recipient": dtmf});
  }

  Future<bool> toggleSpeaker() async {
    return await _methodChannel.invokeMethod('toggleSpeaker');
  }

  Future<bool> toggleMic() async {
    return await _methodChannel.invokeMethod('toggleMic');
  }

  Future<bool> refreshSipAccount() async {
    return await _methodChannel.invokeMethod('refreshSipAccount');
  }

  Future<bool> unregisterSipAccount() async {
    return await _methodChannel.invokeMethod('unregisterSipAccount');
  }

  Future<String> getCallId() async {
    return await _methodChannel.invokeMethod('getCallId');
  }

  Future<int> getMissedCalls() async {
    return await _methodChannel.invokeMethod('getMissedCalls');
  }

  Future<String> getSipRegistrationState() async {
    return await _methodChannel.invokeMethod('getSipRegistrationState');
  }

  Future<bool> isMicEnabled() async {
    return await _methodChannel.invokeMethod('isMicEnabled');
  }

  Future<bool> isSpeakerEnabled() async {
    return await _methodChannel.invokeMethod('isSpeakerEnabled');
  }

  Future<bool> setCodecs(Codecs codec, bool isEnable) async {
    return await _methodChannel.invokeMethod('setCodecs', {"codecs": codec.value, "isEnable": isEnable});
  }

// Future<void> registerPush() async {
//   return await _methodChannel.invokeMethod('registerPush');
// }
}
