import 'package:bukutugas/providers/auth/auth_controller.dart';
import 'package:bukutugas/repositories/custom_exception.dart';
import 'package:bukutugas/screens/screens.dart';

import 'package:bukutugas/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => AppWrapper(),
        '/auth/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/subject': (context) => SubjectScreen(),
        '/assignment/detail': (context) => DetailAssignmentScreen(),
        '/assignment/create': (context) => CreateAssignmentScreen(),
      },
    );
  }
}

class AppWrapper extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final auth = useProvider(authProvider);

    return ProviderListener(
      provider: authExceptionProvider,
      onChange: (context, StateController<CustomException?> error) {
        if (error.state != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error.state!.message ?? 'Whoops... terjadi kesalahan',
              ),
            ),
          );
        }
      },
      child: auth.when(
        data: (user) => user == null ? LoginScreen() : HomeScreen(),
        loading: () => Splash(),
        error: (_, __) => LoginScreen(),
      ),
    );
  }
}
