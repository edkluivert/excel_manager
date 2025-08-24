import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  final _fln = FlutterLocalNotificationsPlugin();
  final List<String> _scheduledLogs = [];

  Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _fln.initialize(
      const InitializationSettings(
        android: android,
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  Future<void> scheduleDue(String id, String title, DateTime when) async {
    if (when.isBefore(DateTime.now())) {
      log("Tried to schedule overdue task '$title' at $when. Skipped.");
      return;
    }

    try {
      await _fln.zonedSchedule(
        id.hashCode,
        'Task due',
        title,
        tz.TZDateTime.from(when, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'due',
            'Due Tasks',
            channelDescription: 'Notifications for due tasks',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      );

      final logEntry = '✅ Scheduled [$title] for $when';
      _scheduledLogs.add(logEntry);
      log(logEntry);
    } on Exception catch (e) {
      log('Failed to schedule notification: $e');
    }
  }

  Future<void> cancel(String id) async {
    await _fln.cancel(id.hashCode);
    log('Cancelled notification with id: $id');
  }

  List<String> getScheduledLogs() => List.unmodifiable(_scheduledLogs);
}
