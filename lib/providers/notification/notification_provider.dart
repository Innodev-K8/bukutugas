import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/assignment/all_assignments_provider.dart';
import 'package:bukutugas/providers/notification/notification_type_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  Reader _read;

  late FlutterLocalNotificationsPlugin instance;

  NotificationService(this._read) {
    instance = FlutterLocalNotificationsPlugin();
  }

  static const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'Channel Tugas',
    'Tugas',
    'Menampillkan notifikasi tugas.',
    importance: Importance.max,
    priority: Priority.high,
    styleInformation: BigTextStyleInformation(''),
  );

  cancelAllNotifications() {
    instance.cancelAll();
  }

  rescheduleAllNotifications() async {
    instance.cancelAll();

    final NotificationType? type = _read(notificationTypeProvider).type;

    if (type == null) {
      debugPrint('----------ALL NOTIFICATIONS CANCELED----------');

      return;
    }

    final List<Assignment> activeAssignments =
        _read(allAssignmentsListProvider).state;

    debugPrint('----------Preparing for reschedule----------');
    debugPrint(activeAssignments.length.toString());

    for (final assignment in activeAssignments) {
      debugPrint('Will reschedule: ' + (assignment.title ?? '-'));
      await scheduleNotificationForAssignment(assignment);
    }
  }

  Future<void> scheduleNotificationForPending(
      PendingNotificationRequest pending) {
    return scheduleNotificationForAssignment(Assignment(
      id: pending.id.toString(),
      title: pending.title,
      description: pending.body,
      deadline: pending.payload?.split('|')[1],
    ));
  }

  Future<void> scheduleNotificationForAssignment(Assignment assignment) async {
    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    final scheduleTime = getScheduleTime(assignment);

    if (scheduleTime == null ||
        scheduleTime.isBefore(tz.TZDateTime.now(tz.local))) {
      debugPrint('----------------Ignoring this Assignment----------------');

      return;
    }

    debugPrint('Scheduled Notification Time');
    debugPrint(scheduleTime.toString());

    final typeString = _read(notificationTypeProvider).typeString;

    await instance.zonedSchedule(
      assignment.id.hashCode,
      assignment.title,
      "Jangan lupa deadline ${assignment.title} tinggal $typeString lagi",
      scheduleTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: "${assignment.id}|${assignment.deadline}",
    );

    debugPrint('----------------DONE----------------');
  }

  tz.TZDateTime? getScheduleTime(Assignment assignment) {
    if (assignment.deadline == null || assignment.deadline == '') return null;

    final NotificationType? type = _read(notificationTypeProvider).type;

    if (type == null) return null;

    final deadline = DateTime.parse(assignment.deadline!);

    debugPrint(
        '----------------Scheduling ${assignment.title}----------------');

    debugPrint('Parsed Deadline');
    debugPrint(deadline.toString());

    tz.TZDateTime scheduleDt = tz.TZDateTime.from(deadline, tz.local);

    switch (type) {
      case NotificationType.atTime:
        scheduleDt = scheduleDt;
        break;
      case NotificationType.minute5:
        scheduleDt = scheduleDt.subtract(Duration(minutes: 5));
        break;
      case NotificationType.minute30:
        scheduleDt = scheduleDt.subtract(Duration(minutes: 30));
        break;
      case NotificationType.hour1:
        scheduleDt = scheduleDt.subtract(Duration(hours: 1));
        break;
      case NotificationType.hour4:
        scheduleDt = scheduleDt.subtract(Duration(hours: 4));
        break;
      case NotificationType.hour12:
        scheduleDt = scheduleDt.subtract(Duration(hours: 12));
        break;
      case NotificationType.day1:
        scheduleDt = scheduleDt.subtract(Duration(days: 1));
        break;
    }

    return scheduleDt;
  }
}

final notificationProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref.read);
});
