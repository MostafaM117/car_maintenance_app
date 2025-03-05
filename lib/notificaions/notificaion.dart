import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<void> initialize() async {
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,

    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}