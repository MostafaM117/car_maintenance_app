import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../services/notification_storage_service.dart';

class NotiService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationStorageService? _storageService;
  
  NotificationStorageService get _storageServiceInstance {
    _storageService ??= NotificationStorageService();
    return _storageService!;
  }

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

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
      await notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          // Handle notification when it's actually triggered
          final payload = response.payload;
          if (payload != null && payload.startsWith('maintenance_reminder:')) {
            try {
              final parts = payload.split(':');
              if (parts.length >= 4) {
                final id = int.tryParse(parts[1]) ?? 0;
                final title = parts[2];
                final body = parts[3];
                
                await _storageServiceInstance.saveNotification(
                  id: id,
                  title: title,
                  body: body,
                  type: 'maintenance',
                );
                
                print("✅ Maintenance reminder saved to Firestore: $title");
              }
            } catch (e) {
              print("Error handling maintenance reminder: $e");
            }
          }
        },
      );
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

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String type = 'general',
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
      
      // Save notification to Firestore
      await _storageServiceInstance.saveNotification(
        id: id,
        title: title ?? '',
        body: body ?? '',
        type: type,
      );
      
      print("✅ Immediate notification shown and saved: $title");
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
    String type = 'scheduled',
  }) async {
    if (!_isInitialized) await initNotification();

    // Get current date/time
    final now = tz.TZDateTime.now(tz.local);
    print("Current time: $now");
    print("Local timezone: ${tz.local}"); // Debug: Check timezone

    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

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

    await _storageServiceInstance.saveNotification(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate.toLocal(),
      type: type,
    );

    print("Notification scheduled for $scheduledDate and saved to Firestore");
  }

  Future<void> scheduleNotificationAtDate({
    int id = 1,
    required String title,
    required String body,
    required DateTime dateTime,
    String type = 'maintenance',
  }) async {
    try {
      if (!_isInitialized) {
        await initNotification();
      }

      final scheduledDate = tz.TZDateTime.from(dateTime, tz.local);
      
      await notificationsPlugin.cancel(id);

      await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails(isScheduled: true),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
      
      print("✅ Notification scheduled for $scheduledDate (maintenance reminder)");
    } catch (e) {
      print("Failed to schedule notification: $e");
    }
  }

  Future<void> scheduleMaintenanceReminder({
    int id = 1,
    required String title,
    required String body,
    required DateTime reminderDate,
  }) async {
    try {
      if (!_isInitialized) {
        await initNotification();
      }

      final scheduledDate = tz.TZDateTime.from(reminderDate, tz.local);
      
      await notificationsPlugin.cancel(id);

      await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails(isScheduled: true),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        payload: 'maintenance_reminder:$id:$title:$body',
      );
      
      print("✅ Maintenance reminder scheduled for $scheduledDate");
    } catch (e) {
      print("Failed to schedule maintenance reminder: $e");
    }
  }

  Future<void> cancelNotification() async {
    await notificationsPlugin.cancelAll();
  }
}
