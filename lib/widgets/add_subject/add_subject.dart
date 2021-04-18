import 'dart:math';

import 'package:bukutugas/helpers/helpers.dart';
import 'package:bukutugas/providers/available_color_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'color_selector.dart';
import 'day_selector.dart';
import 'emoji_selector.dart';

class AddSubject extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final availableColor = useProvider(availableColorProvider);
    final randomColor = availableColor[Random().nextInt(availableColor.length)];

    final subjectName = useState('');
    final subjectTeacher = useState('');
    final subjectEmoji = useState('📚');
    final subjectColor = useState(randomColor.toHex());
    final subjectDay = useState([]);

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
          Form(
            key: formKey,
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
                        emoji: subjectEmoji.value,
                        onChange: (emoji) => subjectEmoji.value = emoji,
                      ),
                      SizedBox(height: 14.0),
                      ColorSelector(
                        color: HexColor(subjectColor.value),
                        onChange: (color) => subjectColor.value = color.toHex(),
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
                        onSaved: (newValue) => subjectName.value = newValue!,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == '') {
                            return 'Nama mapel harap diisi ya...';
                          }
                        },
                      ),
                      SizedBox(height: 14.0),
                      TextFormField(
                        style: Theme.of(context).textTheme.headline4,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: 'Nama guru/dosen...',
                        ),
                        onSaved: (newValue) => subjectTeacher.value = newValue!,
                      ),
                      SizedBox(height: 14.0),
                      Text('Hari'),
                      SizedBox(height: 8.0),
                      DaySelectorFormField(
                        onSaved: (selectedDays) =>
                            subjectDay.value = selectedDays ?? [],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (selected) {
                          if ((selected ?? []).length <= 0) {
                            return 'Buat hari apa aja nih?';
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                clearFocus(context);

                var validated = formKey.currentState?.validate();

                if (validated == true) {
                  formKey.currentState!.save();

                  print('VALIDATED');
                  print(subjectName.value);
                  print(subjectTeacher.value);
                  print(subjectEmoji.value);
                  print(subjectColor.value);
                  print(subjectDay.value);
                }
              },
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
