import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String? message;

  const ErrorText({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          message ?? 'Ada yang salah',
          style: TextStyle(
            fontSize: 12,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
