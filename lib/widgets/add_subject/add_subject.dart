import 'package:bukutugas/helpers/helpers.dart';
import 'package:flutter/material.dart';

import 'color_selector.dart';
import 'day_selector.dart';
import 'emoji_selector.dart';

class AddSubject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tambah Mapel',
            style: Theme.of(context).textTheme.headline2,
          ),
          SizedBox(height: 24.0),
          Row(
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
                      emoji: '😍',
                      onChange: print,
                    ),
                    SizedBox(height: 14.0),
                    ColorSelector(
                      color: HexColor('#F8A488'),
                      onChange: (color) => print(color.toHex()),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      style: Theme.of(context).textTheme.headline4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Nama mapel...',
                      ),
                    ),
                    SizedBox(height: 14.0),
                    TextFormField(
                      style: Theme.of(context).textTheme.headline4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Nama guru/dosen...',
                      ),
                    ),
                    SizedBox(height: 14.0),
                    Text('Hari'),
                    SizedBox(height: 8.0),
                    DaySelector(
                      onChange: (selectedDays) {
                        print(selectedDays);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Tambah',
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Theme.of(context).primaryColorLight,
                    ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).accentColor,
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
