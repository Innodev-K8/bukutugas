import 'package:bukutugas/styles.dart';
import 'package:flutter/material.dart';

class SubjectItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFF5AA897),
      borderRadius: AppTheme.roundedLg,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/subject');
        },
        borderRadius: AppTheme.roundedLg,
        child: Container(
          height: 120.0,
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '📖',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bahasa Indonesia',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text(
                          '12 Desember, 14:00',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.headline2!.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Transform.translate(
                      offset: Offset(10, -10),
                      child: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '3 Tugas',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    'Pak Doni',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
