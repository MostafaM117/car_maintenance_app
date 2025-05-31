import 'package:car_maintenance/generated/l10n.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String date;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.isRead = false,
  });
}

class NotificationsPage extends StatefulWidget {
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // بيانات ثابتة
  List<NotificationModel> notifications = [
    NotificationModel(
      id: 1,
      title: 'Maintenance Reminder',
      body: 'Your car needs maintenance soon.',
      date: '2024-06-01',
      isRead: false,
    ),
    NotificationModel(
      id: 2,
      title: 'Offer Available',
      body: 'Special discount on oil change!',
      date: '2024-05-28',
      isRead: true,
    ),
    NotificationModel(
      id: 3,
      title: 'Insurance Expiry',
      body: 'Your insurance will expire in 10 days.',
      date: '2024-05-25',
      isRead: false,
    ),
  ];

  void markAsRead(int index) {
    setState(() {
      notifications[index].isRead = true;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    S.of(context).notifications,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontFamily: 'Inter',
                      height: 0,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Stream builder to display all user cars
                  Expanded(
                    child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return GestureDetector(
                          onTap: () => markAsRead(index),
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
                                // هيبقي هنا لوجو الابلكيشن لما حبيبه تعمله
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            notification.title,
                                            style: textStyleWhite.copyWith(
                                                color: AppColors.buttonColor),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            notification.date,
                                            style: textStyleGray,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        notification.body,
                                        style: textStyleGray,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
