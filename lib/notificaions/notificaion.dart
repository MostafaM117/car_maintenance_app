import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initialize() async {
<<<<<<< HEAD
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  
    final InitializationSettings initializationSettings = InitializationSettings(
=======
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
>>>>>>> 56a1057f8c236f76b1cf9e555b38232705fa30a6
      android: initializationSettingsAndroid,

    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}
