import 'package:dog/firebase_options.dart';
import 'package:dog/src/repository/chat_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseCloudMessage().setupFlutterNotifications();
}

class FirebaseCloudMessage {
  bool isFlutterLocalNotificationsInitialized = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications',
      importance: Importance.max
  );
  final AndroidInitializationSettings android = const AndroidInitializationSettings("@mipmap/ic_launcher");

  Future<void> foreground() async {
    final InitializationSettings settings = InitializationSettings(android: android);
    flutterLocalNotificationsPlugin.initialize(settings);

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      debugPrint('수신!!');
      debugPrint(message?.data.toString());

      if (message != null) {
        showFlutterNotification(message);
      }
    });

  }

  Future<void> terminated() async {
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      //TODO 채팅방으로 이동 기능
    });
  }

  Future<void> setupFlutterNotifications() async {

    if (isFlutterLocalNotificationsInitialized) {
      return;
    }

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: channel.importance,
            priority: Priority.high
          )
        )
      );
    }
  }

  Future<void> tokenHandler() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      debugPrint('''
      
      /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/
      
      FCM Token: $token
      
      /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/
      
      ''');
      ChatRepository().postFCMToken(token: token);
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {

      debugPrint('''
      
      /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/
      FCM Token refresh: $token
      /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/
      
      ''');
      ChatRepository().postFCMToken(token: token);
    }).onError((err) {
      //TODO 에러 핸들링
    });
  }
}