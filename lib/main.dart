import 'package:bukutugas/screens/assignment/create_assignment_screen.dart';
import 'package:bukutugas/screens/home/home_screen.dart';
import 'package:bukutugas/screens/subject/subject_screen.dart';
import 'package:bukutugas/styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
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
        '/': (context) => HomeScreen(),
        '/subject': (context) => SubjectScreen(),
        '/assignment/create': (context) => CreateAssignmentScreen(),
      },
    );
  }
}
