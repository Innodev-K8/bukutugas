import 'package:flutter/material.dart';

import 'package:bukutugas/widgets/widgets.dart';

class SubjectHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 28 + 24 * 2,
              padding: const EdgeInsets.all(24.0),
              child: Stack(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(24.0),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.chevron_left,
                      color: Theme.of(context).primaryColorLight,
                      size: 28.0,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Bahasa Indonesia',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70.0,
                    padding: const EdgeInsets.only(right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        EmojiSelector(
                          emoji: '📚',
                          readOnly: true,
                        ),
                        SizedBox(height: 14.0),
                        ColorSelector(
                          color: Theme.of(context).backgroundColor,
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bahasa Indonesia aaaaaaaaaa',
                          style: Theme.of(context).textTheme.headline1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Pak Dewa aaaaaaaaaa',
                          style:
                              Theme.of(context).textTheme.headline3!.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 14.0),
                        Text(
                          'Hari',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                        ),
                        SizedBox(height: 8.0),
                        DaySelectorFormField(
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
