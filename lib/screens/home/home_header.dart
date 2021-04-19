import 'package:bukutugas/controllers/auth_controller.dart';
import 'package:bukutugas/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeHeader extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final user = useProvider(userProvider)!;

    return Container(
      padding: const EdgeInsets.only(top: 64, bottom: 8),
      width: double.infinity,
      child: Stack(
        children: [
          Column(
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
          Positioned(
            top: 0,
            right: 24,
            child: InkWell(
              onTap: () {
                context.read(authControllerProvider.notifier).signOut();
              },
              child: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          )
        ],
      ),
    );
  }
}
