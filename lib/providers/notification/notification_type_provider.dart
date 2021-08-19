import 'package:bukutugas/providers/shared_preference_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum NotificationType { atTime, minute5, minute30, hour1, hour4, hour12, day1 }

NotificationType? parseNotificationTypeString(String? notificationType) {
  switch (notificationType) {
    case 'atTime':
      return NotificationType.atTime;
    case 'minute5':
      return NotificationType.minute5;
    case 'minute30':
      return NotificationType.minute30;
    case 'hour1':
      return NotificationType.hour1;
    case 'hour4':
      return NotificationType.hour4;
    case 'hour12':
      return NotificationType.hour12;
    case 'day1':
      return NotificationType.day1;
    default:
      return null;
  }
}

String notificationTypeToString(NotificationType? notificationType) {
  switch (notificationType) {
    case NotificationType.atTime:
      return 'Tepat Waktu';
    case NotificationType.minute5:
      return '5 Menit';
    case NotificationType.minute30:
      return '30 menit';
    case NotificationType.hour1:
      return '1 jam';
    case NotificationType.hour4:
      return '4 jam';
    case NotificationType.hour12:
      return '12 jam';
    case NotificationType.day1:
      return '1 hari';
    default:
      return '';
  }
}

String getNotificationTypeString(NotificationType? notificationType) {
  if (notificationType == null) return '';

  return notificationType.toString().split('.')[1];
}

class NotificationTypeService extends ChangeNotifier {
  final storeKey = 'NOTIFICATION_TYPE';

  Reader _read;

  NotificationTypeService(this._read);

  NotificationType? get type {
    final notificationTypeString =
        _read(sharedPreferenceProvider).getString(storeKey);

    return parseNotificationTypeString(notificationTypeString);
  }

  set type(NotificationType? notificationType) {
    _read(sharedPreferenceProvider)
        .setString(storeKey, getNotificationTypeString(notificationType));

    notifyListeners();
  }

  String get typeString {
    return notificationTypeToString(type);
  }
}

final notificationTypeProvider =
    ChangeNotifierProvider<NotificationTypeService>((ref) {
  return NotificationTypeService(ref.read);
});
