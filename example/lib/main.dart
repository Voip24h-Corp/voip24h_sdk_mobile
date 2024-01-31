import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:callkeep/callkeep.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info/device_info.dart';
import 'package:voip24h_sdk_mobile/voip24h_sdk_mobile.dart';
import 'package:voip24h_sdk_mobile/callkit/utils/sip_event.dart';
import 'package:voip24h_sdk_mobile/callkit/utils/transport_type.dart';
import 'package:voip24h_sdk_mobile/graph/extensions/extensions.dart';
import 'package:voip24h_sdk_mobile/callkit/model/sip_configuration.dart';
import 'package:voip24h_sdk_mobile_example/LocalNotificationService.dart';
import 'package:permission_handler/permission_handler.dart';


// region Setup Firebase messaging
FirebaseMessaging messaging = FirebaseMessaging.instance;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
bool isFlutterLocalNotificationsInitialized = false;
late AndroidNotificationChannel channel;
var localNotificationService = LocalNotificationService();
StreamSubscription<dynamic>? observeEvent;
// Key request API Graph
const API_KEY = "c3axxxxxxx";
const API_SECERT = "8a2xxxxxx";
var tokenGraph = "";
var tokenPushIOS = "";
var callId = "";
var sipConfiguration = SipConfigurationBuilder(extension: "extension", domain: "ip", password: "pass")
    .setKeepAlive(true)
    .setPort(5060)
    .setTransport(TransportType.Udp)
    .build();
final FlutterCallkeep callKeep = FlutterCallkeep();

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'incoming_call', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  isFlutterLocalNotificationsInitialized = true;
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if(Platform.isAndroid) {
    print("Handling a background message: ${message.data}");
    await Firebase.initializeApp().whenComplete(() => {
      localNotificationService.initialNotification().then((value) => {
        testCallKit()
      })
    });
    // await setupFlutterNotifications();
    // showFlutterNotification(message);
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
  }
}
// endregion

Future<void> main() async {
  // region Initial Firebase messaging and Initial Firebase message Background
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isAndroid) {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  // endregion
  localNotificationService.initialNotification();
  runApp(const MyApp());
}

Future<void> testCallKit() async {
  Voip24hSdkMobile.callModule.initSipModule(sipConfiguration);
  if(observeEvent != null) {
    await observeEvent!.cancel();
  }
  observeEvent = Voip24hSdkMobile.callModule.eventStreamController.stream.listen((event) {
    switch (event['event']) {
      case SipEvent.AccountRegistrationStateChanged: {
        var body = event['body'];
        print(body);
      }
      break;
      case SipEvent.Ring: {
        var body = event['body'];
        print("Ring");
        if(body['callType'] == "inbound") {
          if(Platform.isIOS) {
            if(callId.isNotEmpty) {
              callKeep.updateDisplay(callId, callerName: "updated", handle: "generic");
            } else {
              const uuid = Uuid();
              String newUuid = uuid.v4();
              callId = newUuid;
              callKeep.displayIncomingCall(newUuid, "generic", callerName: body['phoneNumber']);
            }
          } else if(Platform.isAndroid) {
            localNotificationService.showNotification(body: "Incoming call ${body['phoneNumber']}");
          }
        }
      }
      break;
      case SipEvent.Up: {
        var body = event['body'];
      }
      break;
      case SipEvent.Hangup: {
        var body = event['body'];
        callKeep.endAllCalls();
        callId = "";
      }
      break;
      case SipEvent.Paused: {
      }
      break;
      case SipEvent.Resuming: {
      }
      break;
      case SipEvent.Missed: {
        var body = event['body'];
      }
      break;
      case SipEvent.Error: {
        var body = event['body'];
      }
      break;
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  Future<void> testGraph() async {
    var oauth = await Voip24hSdkMobile.graphModule.getAccessToken(apiKey: API_KEY, apiSecert: API_SECERT);
    var body = {"offset": "0"};
    Voip24hSdkMobile.graphModule.sendRequest(token: oauth.token, endpoint: "call/find", body: body).then((value) => {
          print(value.getDataList()),
          print(value.statusCode()),
          print(value.message()),
          print(value.limit()),
          print(value.offset()),
          print(value.total()),
          print(value.isSort()),
        },
        onError: (error) => {
          print(error)
        }
    );
  }

  @override
  void initState() {
    super.initState();
    requestPermissionMicroPhone();
    initPlatformState();
    testCallKit();

    if(Platform.isAndroid) {
      requestPermissionNotification();
    } else if (Platform.isIOS) {
      configureCallKeep();
    }
  }

  // region Request Permission Notification and Initial Firebase message Foreground
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
      platformVersion = await Voip24hSdkMobile.platformVersion ?? 'Unknown platform version';
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
    var oauth = await Voip24hSdkMobile.graphModule.getAccessToken(apiKey: API_KEY, apiSecert: API_SECERT);
    tokenGraph = oauth.token;
    print(tokenGraph);
  }

  void call(String phoneNumber) {
    Voip24hSdkMobile.callModule.call(phoneNumber).then((value) => {
      print(value)
    }, onError: (error) => {
      print(error)
    });
  }

  void hangup() {
    Voip24hSdkMobile.callModule.hangup().then((value) => {
      print(value)
    }, onError: (error) => {
      print(error)
    });
  }

  void answer() {
    Voip24hSdkMobile.callModule.answer().then((value) => {
      print(value.toString())
    }, onError: (error) => {
      print(error)
    });
  }

  void reject() {
    Voip24hSdkMobile.callModule.reject().then((value) => {
      print(value)
    }, onError: (error) => {
      print(error)
    });
  }

  void pause() {
    Voip24hSdkMobile.callModule.pause().then((value) => {
      print(value)
    }, onError: (error) => {
      print(error)
    });
  }

  void resume() {
    Voip24hSdkMobile.callModule.resume().then((value) => {
      print(value.toString())
    }, onError: (error) => {
      print(error)
    });
  }

  void transfer(String extension) {
    Voip24hSdkMobile.callModule.transfer(extension).then((value) => {
      print(value.toString())
    }, onError: (error) => {
      print(error)
    });
  }

  void toggleMic() {
    Voip24hSdkMobile.callModule.toggleMic().then((value) => {
      print(value)
    }, onError: (error) => {
      print(error)
    });
  }

  void toggleSpeaker() {
    Voip24hSdkMobile.callModule.toggleSpeaker().then((value) => {
      print(value)
    }, onError: (error) => {
      print(error)
    });
  }

  void getMissedCalls() {
    Voip24hSdkMobile.callModule.getMissedCalls().then((value) => {
      print(value)
    }, onError: (error) => {
      print(error)
    });
  }

  void getRegistrationState() {
    Voip24hSdkMobile.callModule.getSipRegistrationState().then((value) => {
      print(value)
    }, onError: (error) {
    });
  }

  void isMicEnabled() {
    Voip24hSdkMobile.callModule.isMicEnabled().then((value) => print(value));
  }

  void isSpeakerEnabled() {
    Voip24hSdkMobile.callModule.isSpeakerEnabled().then((value) => print(value));
  }

  void getCallId() {
    Voip24hSdkMobile.callModule.getCallId().then((value) => {
      print(value)
    }, onError: (error) => {
      print(error)
    });
  }

  void sendDTMF(String dtmf) {
    Voip24hSdkMobile.callModule.sendDTMF(dtmf).then((value) => {
      print(value)
    }, onError: (error) => {
      print(error)
    });
  }

  void refreshSipAccount() {
    Voip24hSdkMobile.callModule.refreshSipAccount().then((value) => {
      print(value)
    }, onError: (error) => {
      print(error)
    });
  }

  void unregisterSipAccount() {
    Voip24hSdkMobile.callModule.unregisterSipAccount().then((value) => {
      print(value)
    }, onError: (error) => {
      print(error)
    });
  }

  void registerPushForAndroid() async {
    String? token = await messaging.getToken();
    if(token != null) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      print(packageInfo.packageName);
      Voip24hSdkMobile.pushNotificationModule.registerPushNotification(
          tokenGraph: tokenGraph,
          token: token,
          sipConfiguration: sipConfiguration,
          isAndroid: true,
          appId: packageInfo.packageName,
          isProduction: false,
          deviceMac: androidDeviceInfo.androidId
      ).then((value) => {
        print(value)
      }, onError: (error) => {
        print(error)
      });
    } else {
      print("Token push android not found");
    }
  }

  void registerPushForIOS() async {
    if(tokenPushIOS.isNotEmpty) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      Voip24hSdkMobile.pushNotificationModule.registerPushNotification(
          tokenGraph: tokenGraph,
          token: tokenPushIOS,
          sipConfiguration: sipConfiguration,
          isIOS: true,
          appId: packageInfo.packageName,
          isProduction: false,
          deviceMac: iosDeviceInfo.identifierForVendor
      ).then((value) => {
        print(value)
      }, onError: (error) => {
        print(error)
      });
    } else {
      print("Token push ios not found");
    }
  }

  Future<void> configureCallKeep() async {
    callKeep.on<CallKeepPushKitToken>((value) => {
      tokenPushIOS = value.token ?? ""
    });
    callKeep.on<CallKeepReceivedPushNotification>((value) => {
      callId = value.callId ?? "",
      testCallKit()
    });
    callKeep.on<CallKeepPerformAnswerCallAction>((value) => {
      answer()
    });
    callKeep.on<CallKeepPerformEndCallAction>((value) => {
      reject()
    });
    callKeep.setup(context, <String, dynamic>{
      'ios': {
        'appName': 'Example',
      }
    });
  }

  void unregisterPushNotification() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Voip24hSdkMobile.pushNotificationModule.unregisterPushNotification(
        sipConfiguration: sipConfiguration,
        isAndroid: true,
        appId: packageInfo.packageName
    ).then((value) => {
      print(value)
    }, onError: (error) => {
      print(error)
    });
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
                    testGraph();
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
    Voip24hSdkMobile.callModule.eventStreamController.close();
    super.dispose();
  }
}