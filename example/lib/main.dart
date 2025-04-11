import 'dart:async';
import 'dart:io';

import 'package:callkeep/callkeep.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:voip24h_sdk_mobile/Voip24hSDK.dart';
import 'package:voip24h_sdk_mobile/extensions/Extensions.dart';
import 'package:voip24h_sdk_mobile/models/SipConfiguration.dart';
import 'package:voip24h_sdk_mobile/utils/CallEvent.dart';
import 'package:voip24h_sdk_mobile/utils/Codecs.dart';
import 'package:voip24h_sdk_mobile/utils/GraphRoute.dart';
import 'package:voip24h_sdk_mobile/utils/TransportType.dart';
import 'package:voip24h_sdk_mobile_example/LocalNotificationService.dart';

// ------------------------------------------------------------------------ //
// Setup Push notification
FirebaseMessaging messaging = FirebaseMessaging.instance;
var localNotificationService = LocalNotificationService();
final FlutterCallkeep callKeep = FlutterCallkeep();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Platform.isAndroid) {
    print("Handling a background message: ${message.data}");
    await Firebase.initializeApp().whenComplete(() {
      localNotificationService.initialNotification().then((value) => {setupCallKit()});
    });
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
  }
}
// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
// bool isFlutterLocalNotificationsInitialized = false;
// late AndroidNotificationChannel channel;

// ------------------------------------------------------------------------ //
// Setup Graph API
const API_KEY = "c3axxxxxxx";
const API_SECRET = "8a2xxxxxx";
var tokenGraph = "";

// ------------------------------------------------------------------------ //
// Setup CallKit
StreamSubscription<dynamic>? observeEvent;
var tokenPushIOS = "";
var callId = "";
var sipConfiguration = SipConfigurationBuilder(extension: "extension", domain: "ip", password: "password")
    .setKeepAlive(true)
    .setPort(5060)
    .setTransport(TransportType.Udp)
    .build();

Future<void> setupCallKit() async {
  Voip24hSDK.callModule.initSipModule(sipConfiguration);
  if (observeEvent != null) {
    await observeEvent!.cancel();
  }
  observeEvent = Voip24hSDK.callModule.eventStreamController.stream.listen((event) {
    switch (event['event']) {
      case CallEvent.AccountRegistrationStateChanged:
        {
          var body = event['body'];
          print(body);
        }
        break;
      case CallEvent.Ring:
        {
          var body = event['body'];
          print("Ring");
          if (body['callType'] == "inbound") {
            if (Platform.isIOS) {
              if (callId.isNotEmpty) {
                callKeep.updateDisplay(callId, callerName: "updated", handle: "generic");
              } else {
                const uuid = Uuid();
                String newUuid = uuid.v4();
                callId = newUuid;
                callKeep.displayIncomingCall(newUuid, "generic", callerName: body['phoneNumber']);
              }
            } else if (Platform.isAndroid) {
              localNotificationService.showNotification(body: "Incoming call ${body['phoneNumber']}");
            }
          }
        }
        break;
      case CallEvent.Up:
        {
          var body = event['body'];
        }
        break;
      case CallEvent.Hangup:
        {
          var body = event['body'];
          callKeep.endAllCalls();
          callId = "";
        }
        break;
      case CallEvent.Paused:
        {}
        break;
      case CallEvent.Resuming:
        {}
        break;
      case CallEvent.Missed:
        {
          var body = event['body'];
        }
        break;
      case CallEvent.Error:
        {
          var body = event['body'];
        }
        break;
    }
  });
}

// ------------------------------------------------------------------------ //
Future<void> main() async {
  // Initial Firebase messaging and Initial Firebase message Background
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  localNotificationService.initialNotification();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  Future<void> setupGraphAPI() async {
    var oauth = await Voip24hSDK.graphModule.getAccessToken(apiKey: API_KEY, apiSecret: API_SECRET);
    var body = {"callid": "174xxxxxx"};
    Voip24hSDK.graphModule.sendRequest(token: oauth.token, route: GraphRoute.CallLog, params: body).then(
        (value) => {
              print(value.getData()),
              print(value.statusCode()),
              print(value.message()),
              print(value.limit()),
              print(value.offset()),
              print(value.total()),
            },
        onError: (error) => {print(error)});
  }

  @override
  void initState() {
    super.initState();
    requestPermissionMicroPhone();
    initPlatformState();
    setupCallKit();

    if (Platform.isAndroid) {
      requestPermissionNotification();
    } else if (Platform.isIOS) {
      configureCallKeep();
    }
  }

  // Request Permission Notification and Initial Firebase message Foreground
  Future<void> requestPermissionNotification() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<void> requestPermissionMicroPhone() async {
    await Permission.microphone.request();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await Voip24hSDK.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> getTokenGraph() async {
    var oauth = await Voip24hSDK.graphModule.getAccessToken(apiKey: API_KEY, apiSecret: API_SECRET);
    tokenGraph = oauth.token;
    print(tokenGraph);
  }

  void call(String phoneNumber) {
    Voip24hSDK.callModule.call(phoneNumber).then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void hangup() {
    Voip24hSDK.callModule.hangup().then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void answer() {
    Voip24hSDK.callModule.answer().then((value) => {print(value.toString())}, onError: (error) => {print(error)});
  }

  void reject() {
    Voip24hSDK.callModule.reject().then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void pause() {
    Voip24hSDK.callModule.pause().then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void resume() {
    Voip24hSDK.callModule.resume().then((value) => {print(value.toString())}, onError: (error) => {print(error)});
  }

  void transfer(String extension) {
    Voip24hSDK.callModule.transfer(extension).then((value) => {print(value.toString())}, onError: (error) => {print(error)});
  }

  void toggleMic() {
    Voip24hSDK.callModule.toggleMic().then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void toggleSpeaker() {
    Voip24hSDK.callModule.toggleSpeaker().then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void getMissedCalls() {
    Voip24hSDK.callModule.getMissedCalls().then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void getRegistrationState() {
    Voip24hSDK.callModule.getSipRegistrationState().then((value) => {print(value)}, onError: (error) {});
  }

  void isMicEnabled() {
    Voip24hSDK.callModule.isMicEnabled().then((value) => print(value));
  }

  void isSpeakerEnabled() {
    Voip24hSDK.callModule.isSpeakerEnabled().then((value) => print(value));
  }

  void getCallId() {
    Voip24hSDK.callModule.getCallId().then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void sendDTMF(String dtmf) {
    Voip24hSDK.callModule.sendDTMF(dtmf).then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void refreshSipAccount() {
    Voip24hSDK.callModule.refreshSipAccount().then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void unregisterSipAccount() {
    Voip24hSDK.callModule.unregisterSipAccount().then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void setCodecs(Codecs codec, bool isEnable) {
    Voip24hSDK.callModule.setCodecs(codec, isEnable).then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void registerPushForAndroid() async {
    String? token = await messaging.getToken();
    if (token != null) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      print(packageInfo.packageName);
      print(androidDeviceInfo.id);
      Voip24hSDK.pushNotificationModule
          .registerPushNotification(
              tokenGraph: tokenGraph,
              token: token,
              sipConfiguration: sipConfiguration,
              isAndroid: true,
              appId: packageInfo.packageName,
              isProduction: false,
              deviceMac: androidDeviceInfo.id)
          .then((value) => {print(value)}, onError: (error) => {print(error)});
    } else {
      print("Token push android not found");
    }
  }

  void registerPushForIOS() async {
    if(tokenPushIOS.isNotEmpty) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      print(iosDeviceInfo.identifierForVendor);
      Voip24hSDK.pushNotificationModule
          .registerPushNotification(
              tokenGraph: tokenGraph,
              token: tokenPushIOS,
              sipConfiguration: sipConfiguration,
              isIOS: true,
              appId: packageInfo.packageName,
              isProduction: false,
              deviceMac: iosDeviceInfo.identifierForVendor ?? "")
          .then((value) => {print(value)}, onError: (error) => {print(error)});
    } else {
      print("Token push ios not found");
    }
  }

  Future<void> configureCallKeep() async {
    callKeep.on<CallKeepPushKitToken>((value) {
      tokenPushIOS = value.token ?? "";
    });
    callKeep.on<CallKeepReceivedPushNotification>((value) {
      callId = value.callId ?? "";
      setupCallKit();
    });
    callKeep.on<CallKeepPerformAnswerCallAction>((value) {
      answer();
    });
    callKeep.on<CallKeepPerformEndCallAction>((value) {
      reject();
    });
    callKeep.setup(context, <String, dynamic>{
      'ios': {
        'appName': 'Example',
      }
    });
  }

  void unregisterPushNotification() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Voip24hSDK.pushNotificationModule
        .unregisterPushNotification(sipConfiguration: sipConfiguration, isAndroid: true, appId: packageInfo.packageName)
        .then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.all(12.0), child: Text('Running on: $_platformVersion\n')),
                OutlinedButton(
                  child: const Text('Get token Graph'),
                  onPressed: () {
                    getTokenGraph();
                  },
                ),
                OutlinedButton(
                  child: const Text('Register push notification for Android'),
                  onPressed: () {
                    registerPushForAndroid();
                  },
                ),
                OutlinedButton(
                  child: const Text('Register push notification for IOS'),
                  onPressed: () {
                    registerPushForIOS();
                  },
                ),
                OutlinedButton(
                  child: const Text('Test Graph'),
                  onPressed: () {
                    setupGraphAPI();
                  },
                ),
                OutlinedButton(
                  child: const Text('Call'),
                  onPressed: () {
                    call("phoneNumber");
                  },
                ),
                OutlinedButton(
                  child: const Text('Hangup'),
                  onPressed: () {
                    hangup();
                  },
                ),
                OutlinedButton(
                  child: const Text('Answer'),
                  onPressed: () {
                    answer();
                  },
                ),
                OutlinedButton(
                  child: const Text('Reject'),
                  onPressed: () {
                    reject();
                  },
                ),
                OutlinedButton(
                  child: const Text('Pause'),
                  onPressed: () {
                    pause();
                  },
                ),
                OutlinedButton(
                  child: const Text('Resume'),
                  onPressed: () {
                    resume();
                  },
                ),
                OutlinedButton(
                  child: const Text('Transfer'),
                  onPressed: () {
                    transfer("extension");
                  },
                ),
                OutlinedButton(
                  child: const Text('Toggle mic'),
                  onPressed: () {
                    toggleMic();
                  },
                ),
                OutlinedButton(
                  child: const Text('Toggle speaker'),
                  onPressed: () {
                    toggleSpeaker();
                  },
                ),
                OutlinedButton(
                  child: const Text('Send DTMF'),
                  onPressed: () {
                    sendDTMF("2#");
                  },
                ),
                OutlinedButton(
                  child: const Text('Get call id'),
                  onPressed: () {
                    getCallId();
                  },
                ),
                OutlinedButton(
                  child: const Text('Get missed calls'),
                  onPressed: () {
                    getMissedCalls();
                  },
                ),
                OutlinedButton(
                  child: const Text('Is mic enabled'),
                  onPressed: () {
                    isMicEnabled();
                  },
                ),
                OutlinedButton(
                  child: const Text('Is speaker enabled'),
                  onPressed: () {
                    isSpeakerEnabled();
                  },
                ),
                OutlinedButton(
                  child: const Text('Set codec G722'),
                  onPressed: () {
                    setCodecs(Codecs.G722, true);
                  },
                ),
                OutlinedButton(
                  child: const Text('Get registration state'),
                  onPressed: () {
                    getRegistrationState();
                  },
                ),
                OutlinedButton(
                  child: const Text('Refresh sip account'),
                  onPressed: () {
                    refreshSipAccount();
                  },
                ),
                OutlinedButton(
                  child: const Text('Unregister sip account'),
                  onPressed: () {
                    unregisterSipAccount();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Voip24hSDK.callModule.eventStreamController.close();
    super.dispose();
  }
}