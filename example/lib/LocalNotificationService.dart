import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {

  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialNotification() async {
    AndroidInitializationSettings initializationAndroidSettings = const AndroidInitializationSettings('@drawable/launch_background');

    // var initializationIOSSettings = DarwinInitializationSettings(
    //   requestAlertPermission: true,
    //   requestBadgePermission: true,
    //   requestCriticalPermission: true,
    //   requestSoundPermission: true,
    //   onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {}
    // );

    var initializationSettings = InitializationSettings(android: initializationAndroidSettings);
    await _notificationsPlugin.initialize(initializationSettings);
    return Future.value();
  }

  _notificationDetails() {
    return const NotificationDetails(android: AndroidNotificationDetails(
        "channelId",
        "channelName",
        importance: Importance.max,
        priority: Priority.high,
        category: AndroidNotificationCategory.call,
        autoCancel: false
    ));
  }

  Future<void> showNotification({int id = 0, String? title, String? body, String? payload}) async {
    return _notificationsPlugin.show(id, title, body, _notificationDetails());
  }
}