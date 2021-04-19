import 'package:bukutugas/helpers/helpers.dart';
import 'package:bukutugas/providers/assignment/assignment_list_provider.dart';
import 'package:bukutugas/styles.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateAssignmentScreen extends HookWidget {
  static const HERO_KEY = 'CREATE_ASSIGNMENT';

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final title = useState('');
    final description = useState('');
    final deadline = useState('');
    final attachments = useState([]);

    return Scaffold(
        backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
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
                          color: Theme.of(context).backgroundColor,
                          size: 28.0,
                        ),
                      ),
                      Center(
                        child: Text(
                          'Tambah Tugas',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Judul',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(height: 14.0),
                        TextFormField(
                          style: Theme.of(context).textTheme.headline4,
                          textCapitalization: TextCapitalization.sentences,
                          decoration:
                              InputDecoration(labelText: 'Tugas Kalkulus...'),
                          validator: (value) {
                            if (value == '') {
                              return 'Tugas apa nih...';
                            }
                          },
                          onSaved: (newValue) => title.value = newValue!,
                        ),
                        SizedBox(height: 14.0),
                        Text(
                          'Deskripsi',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(height: 14.0),
                        TextFormField(
                          style: Theme.of(context).textTheme.headline4,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            labelText: 'Halaman 3...',
                            alignLabelWithHint: true,
                          ),
                          minLines: 8,
                          maxLines: 10,
                          onSaved: (newValue) => description.value = newValue!,
                        ),
                        SizedBox(height: 14.0),
                        Text(
                          'Deadline',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(height: 14.0),
                        DateTimePicker(
                          type: DateTimePickerType.dateTime,
                          initialValue: '',
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          dateLabelText: 'Date',
                          validator: (val) {
                            if (val != null && val != '') {
                              if (DateTime.parse(val)
                                  .isBefore(DateTime.now())) {
                                return 'Yah tanggal & jam ini udah lewat...';
                              }
                            }

                            return null;
                          },
                          onSaved: (newValue) => deadline.value = newValue!,
                          icon: Icon(Icons.today),
                        ),
                        SizedBox(height: 14.0),
                        Container(
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Opacity(
                                opacity: 0.5,
                                child: Column(
                                  children: [
                                    Text(
                                      'Lampiran',
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                    SizedBox(height: 14.0),
                                    Wrap(
                                      children: [
                                        DottedBorder(
                                          color: darken(
                                            Theme.of(context)
                                                .bottomSheetTheme
                                                .backgroundColor!,
                                            0.4,
                                          ),
                                          strokeWidth: 2,
                                          radius: AppTheme.rounded.topLeft,
                                          borderType: BorderType.RRect,
                                          child: Container(
                                            width: 64,
                                            height: 64,
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).shadowColor,
                                              borderRadius: AppTheme.rounded,
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: darken(
                                                Theme.of(context)
                                                    .bottomSheetTheme
                                                    .backgroundColor!,
                                                0.4,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Otw, masih dibikin 😉',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                          color: Colors.red[400],
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 14.0),
                        Container(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              clearFocus(context);

                              if (!formKey.currentState!.validate()) {
                                return;
                              }

                              formKey.currentState!.save();

                              context
                                  .read(assignmentListProvider.notifier)
                                  .addAssignment(
                                    title: title.value,
                                    description: description.value,
                                    deadline: deadline.value,
                                  );

                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Simpan',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).accentColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
