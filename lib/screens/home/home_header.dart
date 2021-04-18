import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 64, bottom: 8),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 72.0 / 2,
            child: Image.network(
              'https://cdn2.iconfinder.com/data/icons/avatars-99/62/avatar-370-456322-512.png',
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Hi Tio',
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
    );
  }
}
