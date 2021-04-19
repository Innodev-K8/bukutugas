import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      body: Center(
        child: Text(
          'Buku Tugas',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}
