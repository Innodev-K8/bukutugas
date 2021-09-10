import 'package:bukutugas/providers/auth/auth_controller.dart';
import 'package:bukutugas/providers/notification/notification_provider.dart';
import 'package:bukutugas/providers/notification/notification_type_provider.dart';
import 'package:bukutugas/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeHeader extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final user = useProvider(userProvider)!;
    final NotificationType? notificationType =
        useProvider(notificationTypeProvider).type;

    return Container(
      padding: const EdgeInsets.only(top: 64, bottom: 8),
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(72.0 / 2),
                  child: CircleAvatar(
                    radius: 72.0 / 2,
                    child: Image.network(
                      user.photoURL ??
                          'https://cdn2.iconfinder.com/data/icons/avatars-99/62/avatar-370-456322-512.png',
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Hi ' + (user.displayName?.split(' ')[0] ?? 'teman'),
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 24.0),
                Text(
                  'Mau ngerjain apa nih hari ini?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 24,
            child: InkWell(
              onTap: () {
                // context.read(notificationProvider).scheduleNotification();
                showAnimatedDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => AlertDialog(
                    insetPadding: const EdgeInsets.all(24.0),
                    actionsPadding: const EdgeInsets.all(0),
                    contentPadding: const EdgeInsets.only(
                      top: 18,
                      bottom: 18,
                      right: 24,
                      left: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTheme.roundedLg,
                    ),
                    title: Text('Notifikasi'),
                    content: NotificationTypeSelector(),
                  ),
                );
              },
              child: Icon(
                notificationType == null
                    ? Icons.notifications_off_rounded
                    : Icons.notifications_rounded,
                color: Theme.of(context).primaryColorLight.withOpacity(0.5),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 24,
            child: InkWell(
              onTap: () {
                context.read(authProvider.notifier).signOut();
              },
              child: Icon(
                Icons.exit_to_app_rounded,
                color: Theme.of(context).primaryColorLight.withOpacity(0.5),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NotificationTypeSelector extends HookWidget {
  const NotificationTypeSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotificationType? notificationType =
        useProvider(notificationTypeProvider).type;

    final selected = useState<NotificationType?>(notificationType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 8,
          children: [
            for (final type in NotificationType.values)
              GestureDetector(
                onTap: () {
                  selected.value = type;
                },
                child: Chip(
                  backgroundColor: selected.value == type
                      ? Theme.of(context).accentColor
                      : Theme.of(context).bottomSheetTheme.backgroundColor,
                  label: Text(
                    notificationTypeToString(type),
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: selected.value == type
                              ? Theme.of(context).primaryColorLight
                              : Theme.of(context).backgroundColor,
                        ),
                  ),
                ),
              ),
            GestureDetector(
              onTap: () {
                selected.value = null;
              },
              child: Chip(
                backgroundColor: selected.value == null
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).bottomSheetTheme.backgroundColor,
                label: Text(
                  'Tanpa Notifikasi',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: selected.value == null
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).backgroundColor,
                      ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Sebelum deadline',
          style: Theme.of(context).textTheme.headline2,
        ),
        SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).accentColor,
            ),
            onPressed: () {
              context.read(notificationTypeProvider).type = selected.value;

              context.read(notificationProvider).rescheduleAllNotifications();

              Navigator.of(context).pop();
            },
            child: Text('Simpan'),
          ),
        ),
      ],
    );
  }
}
