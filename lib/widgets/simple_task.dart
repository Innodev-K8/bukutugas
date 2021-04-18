import 'package:bukutugas/styles.dart';
import 'package:flutter/material.dart';

class SimpleTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColorLight,
      borderRadius: AppTheme.roundedLg,
      child: InkWell(
        onTap: () {
          print('tapped');
        },
        borderRadius: AppTheme.roundedLg,
        child: Container(
          width: 130,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '📖',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 10),
              Text(
                'Membuat Puisi',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontSize: 12.0),
              ),
              SizedBox(height: 4),
              Text(
                '12 Desember, 14:00',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      fontSize: 9.0,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
