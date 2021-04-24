import 'package:bukutugas/providers/shared_preference_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum NotificationType { minute30, hour1, hour4, hour12, day1 }

NotificationType? parseNotificationTypeString(String? notificationType) {
  switch (notificationType) {
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
    switch (type) {
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
}

final notificationTypeProvider =
    ChangeNotifierProvider<NotificationTypeService>((ref) {
  return NotificationTypeService(ref.read);
});
