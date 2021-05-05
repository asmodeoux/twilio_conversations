import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:twilio_programmable_chat_example/debug.dart';
import 'package:twilio_programmable_chat_example/join/join_page.dart';
import 'package:twilio_programmable_chat_example/shared/services/backend_service.dart';

void main() {
  Debug.enabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  _configureNotifications();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(TwilioProgrammableChatExample());
}

//#region Android Notification Handling
// iOS SDK uses APNs and handles notifications internally

void _configureNotifications() {
  if (Platform.isAndroid) {
    FirebaseMessaging().configure(
      onMessage: onMessage,
      onBackgroundMessage: onBackgroundMessage,
      onLaunch: onLaunch,
      onResume: onResume,
    );
    FlutterLocalNotificationsPlugin()
      ..initialize(
        InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
      )
      ..resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>().createNotificationChannel(
        AndroidNotificationChannel(
          '0',
          'Chat',
          'Twilio Chat Channel 0',
        ),
      );
  }
}

// For example purposes, we only setup display of notifications when
// receiving a message while the app is in the background. This behaviour
// appears consistent with the behaviour demonstrated by the iOS SDK
Future<dynamic> onMessage(Map<String, dynamic> message) async {
  print('Main::onMessage => $message');
}

Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) async {
  print('Main::onBackgroundMessage => $message');
  await FlutterLocalNotificationsPlugin().show(
    0,
    message['data']['channel_title'],
    message['data']['twi_body'],
    NotificationDetails(
      android: AndroidNotificationDetails(
        '0',
        'Chat',
        'Twilio Chat Channel 0',
        importance: Importance.high,
        priority: Priority.defaultPriority,
        showWhen: true,
      ),
    ),
    payload: jsonEncode(message),
  );
}

Future<dynamic> onLaunch(Map<String, dynamic> message) async {
  print('Main::onLaunch => $message');
}

Future<dynamic> onResume(Map<String, dynamic> message) async {
  print('Main::onResume => $message');
}
//#endregion

class TwilioProgrammableChatExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<BackendService>(
      create: (_) => FirebaseFunctions.instance,
      child: MaterialApp(
        title: 'Twilio Programmable Chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            color: Colors.blue,
            textTheme: TextTheme(
              headline6: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        home: JoinPage(),
      ),
    );
  }
}
