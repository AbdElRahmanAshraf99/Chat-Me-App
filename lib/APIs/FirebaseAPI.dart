import 'dart:convert';

import 'package:chat_me_app/main.dart';
import 'package:chat_me_app/ui/register.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseAPI {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel('fcm_notifications', 'FCM_Notifications',
      description: 'Description', importance: Importance.defaultImportance);
  final FlutterLocalNotificationsPlugin _localNotification = FlutterLocalNotificationsPlugin();

  initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print("FCM TOKEN:" + fcmToken.toString());
    initPushNotifications();
    initLocalNotificationsMsg();
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMsg);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(_androidChannel.id, _androidChannel.name,
              channelDescription: _androidChannel.description, icon: '@drawable/launcher_icon'),
        ),
        payload: jsonEncode(message.toMap())
      );
    });
  }

  Future initLocalNotificationsMsg() async {
    const ios = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/launcher_icon');
    const settings = InitializationSettings(android: android, iOS: ios);
    await _localNotification.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        final message = RemoteMessage.fromMap(jsonDecode(details.payload!));
        handleMessage(message);
      },
    );
    final platform = _localNotification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState?.pushNamed(RegisterPage.route /*,arguments: message*/);
  }
}

// This fuckin' method must be a top level function
Future<void> handleBackgroundMsg(message) async {
  print(message.notification?.title);
  print(message.notification?.body);
}
