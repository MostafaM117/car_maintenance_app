import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationStorageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _notificationsCollection {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications');
  }

  Future<void> saveNotification({
    required int id,
    required String title,
    required String body,
    DateTime? scheduledDate,
    String type = 'general',
  }) async {
    try {
      await _notificationsCollection.doc(id.toString()).set({
        'id': id,
        'title': title,
        'body': body,
        'date': DateTime.now(),
        'scheduledDate': scheduledDate,
        'type': type,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("✅ Notification saved to Firestore: $title");
    } catch (e) {
      print("❌ Error saving notification: $e");
    }
  }

  // Get all notifications for the current user
  Stream<List<NotificationModel>> getNotifications() {
    return _notificationsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return NotificationModel.fromFirestore(data, doc.id);
      }).toList();
    });
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).update({
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
      print("✅ Notification marked as read: $notificationId");
    } catch (e) {
      print("❌ Error marking notification as read: $e");
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).delete();
      print("✅ Notification deleted: $notificationId");
    } catch (e) {
      print("❌ Error deleting notification: $e");
    }
  }

  Future<void> clearAllNotifications() async {
    try {
      final batch = _firestore.batch();
      final snapshot = await _notificationsCollection.get();
      
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      print("✅ All notifications cleared");
    } catch (e) {
      print("❌ Error clearing notifications: $e");
    }
  }

  Stream<int> getUnreadCount() {
    return _notificationsCollection
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final DateTime? scheduledDate;
  final String type;
  bool isRead;
  final DateTime? readAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.scheduledDate,
    this.type = 'general',
    this.isRead = false,
    this.readAt,
  });

  // Create from Firestore data
  factory NotificationModel.fromFirestore(Map<String, dynamic> data, String id) {
    return NotificationModel(
      id: id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      scheduledDate: (data['scheduledDate'] as Timestamp?)?.toDate(),
      type: data['type'] ?? 'general',
      isRead: data['isRead'] ?? false,
      readAt: (data['readAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convert to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'id': int.tryParse(id) ?? 0,
      'title': title,
      'body': body,
      'date': Timestamp.fromDate(date),
      'scheduledDate': scheduledDate != null ? Timestamp.fromDate(scheduledDate!) : null,
      'type': type,
      'isRead': isRead,
      'readAt': readAt != null ? Timestamp.fromDate(readAt!) : null,
    };
  }

  // Format date for display
  String get formattedDate {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
} 