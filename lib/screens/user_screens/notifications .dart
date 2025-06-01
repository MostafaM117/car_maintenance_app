import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/app_colors.dart';
import '../../services/notification_storage_service.dart';

class NotificationsPage extends StatefulWidget {
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationStorageService _notificationService = NotificationStorageService();
  final user = FirebaseAuth.instance.currentUser;

  void markAsRead(NotificationModel notification) {
    if (!notification.isRead) {
      _notificationService.markAsRead(notification.id);
    }
  }

  void deleteNotification(NotificationModel notification) {
    _notificationService.deleteNotification(notification.id);
  }

  void clearAllNotifications() {
    _notificationService.clearAllNotifications();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'Please log in to view notifications',
            style: textStyleWhite,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  
                  Text(
                    'Notifications',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontFamily: 'Inter',
                      height: 0,
                      letterSpacing: 8,
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  Expanded(
                    child: StreamBuilder<List<NotificationModel>>(
                      stream: _notificationService.getNotifications(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.buttonColor,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error loading notifications',
                              style: textStyleWhite,
                            ),
                          );
                        }

                        final notifications = snapshot.data ?? [];

                        if (notifications.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_off,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No notifications yet',
                                  style: textStyleWhite,
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return Dismissible(
                              key: Key(notification.id),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                deleteNotification(notification);
                              },
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20),
                                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () => markAsRead(notification),
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryText,
                                    border: notification.isRead
                                        ? null
                                        : Border.all(
                                            color: AppColors.borderSide, width: 2),
                                    borderRadius: BorderRadius.circular(22),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey[200],
                                        radius: 22,
                                        child: Icon(Icons.notifications,
                                            color: Colors.grey),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    notification.title,
                                                    style: textStyleWhite.copyWith(
                                                        color: AppColors.buttonColor),
                                                    overflow: TextOverflow.visible,
                                                    softWrap: true,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  notification.formattedDate,
                                                  style: textStyleGray,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              notification.body,
                                              style: textStyleGray,
                                              overflow: TextOverflow.visible,
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          StreamBuilder<List<NotificationModel>>(
            stream: _notificationService.getNotifications(),
            builder: (context, snapshot) {
              final notifications = snapshot.data ?? [];
              if (notifications.isEmpty) {
                return SizedBox.shrink();
              }
              return Positioned(
                top: 20,
                left: 5,
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.grey,
                  onPressed: clearAllNotifications,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
