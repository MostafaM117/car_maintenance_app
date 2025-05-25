import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotiService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // Request Notification Permissions
  Future<void> requestPermissions() async {
    final status = await Permission.notification.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      print("Notification permission denied");
    }
  }

  // Initialize Notifications
  Future<void> initNotification() async {
    if (_isInitialized) {
      return;
    }
    
    // Request permission before initializing
    await requestPermissions();

    // Initialize the timezone
    try {
      tz.initializeTimeZones();
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
    } catch (e) {
      print("Error setting time zone: $e");
    }

    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );

    try {
      await notificationsPlugin.initialize(initSettings);
      _isInitialized = true;
    } catch (e) {
      print("Failed to initialize notification service: $e");
    }
  }

  // Notification Details Setup
  NotificationDetails notificationDetails({bool isScheduled = false}) {
    final AndroidNotificationDetails androidDetails = isScheduled 
        ? const AndroidNotificationDetails(
            'scheduled_channel',
            'Maintenance Reminders',
            channelDescription: 'Notifications for upcoming car maintenance',
            importance: Importance.high,
            priority: Priority.high,
            category: AndroidNotificationCategory.alarm,
            fullScreenIntent: true,
            playSound: true,
            enableVibration: true,
            visibility: NotificationVisibility.public,
          )
        : const AndroidNotificationDetails(
            'default_channel',
            'General Notifications',
            channelDescription: 'General app notifications',
            importance: Importance.max,
            priority: Priority.high,
          );

    return NotificationDetails(
      android: androidDetails,
    );
  }

  // Show Notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    try {
      if (!_isInitialized) {
        print("ℹ️ Notification service not initialized, initializing now");
        await initNotification(); // Ensure initialization
      }

      await notificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails(), // Use defined notification details
      );
      print("✅ Immediate notification shown: $title");
    } catch (e) {
      print("❌ Failed to show notification: $e");
    }
  }

  // Schedule Notification
  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    if (!_isInitialized) await initNotification();

    // Get current date/time
    final now = tz.TZDateTime.now(tz.local);
    print("Current time: $now");
    print("Local timezone: ${tz.local}"); // Debug: Check timezone

    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    // If scheduled time is in the past, schedule it for the next day
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails(isScheduled: true), // Use scheduled notification details
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    print("Notification scheduled for $scheduledDate");
  }

  // Schedule Notification at a specific DateTime
  Future<void> scheduleNotificationAtDate({
    int id = 1,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    try {
      if (!_isInitialized) {
        await initNotification();
      }

      final scheduledDate = tz.TZDateTime.from(dateTime, tz.local);
      
      // Cancel any existing notification with this ID to avoid duplicates
      await notificationsPlugin.cancel(id);

      // Schedule the notification
      await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails(isScheduled: true),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    } catch (e) {
      print("Failed to schedule notification: $e");
    }
  }

  // Cancel all notifications
  Future<void> cancelNotification() async {
    await notificationsPlugin.cancelAll();
  }
}
