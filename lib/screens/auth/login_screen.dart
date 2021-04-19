import 'package:bukutugas/providers/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Buku Tugas',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontSize: Theme.of(context).textTheme.headline1!.fontSize,
                  ),
            ),
            SizedBox(height: 14),
            SignInButton(
              Buttons.Google,
              // text: "Masuk dengan akun Google",
              onPressed: () {
                context.read(authProvider.notifier).signInWithGoogle();
              },
            ),
          ],
        ),
      ),
    );
  }
}
