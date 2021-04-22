import 'dart:io';

import 'package:bukutugas/helpers/helpers.dart';
import 'package:bukutugas/providers/assignment/subject_assignments_provider.dart';
import 'package:bukutugas/repositories/custom_exception.dart';
import 'package:bukutugas/screens/assignment/attachments_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateAssignmentScreen extends HookWidget {
  static const HERO_KEY = 'CREATE_ASSIGNMENT';

  @override
  Widget build(BuildContext context) {
    final isUploadingAssignment =
        useProvider(isUploadingAssignmentProvider).state;

    final formKey = useMemoized(() => GlobalKey<FormState>());

    final title = useState('');
    final description = useState('');
    final deadline = useState('');
    final attachments = useState<List<File>>([]);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
          backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
          body: isUploadingAssignment
              ? Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: ProviderListener(
                    provider: subjectAssignmentsExceptionProvider,
                    onChange:
                        (context, StateController<CustomException?> error) {
                      if (error.state != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              error.state!.message ??
                                  'Whoops... terjadi kesalahan',
                            ),
                          ),
                        );
                      }
                    },
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
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Form(
                            key: formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Judul',
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  SizedBox(height: 14.0),
                                  TextFormField(
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      labelText: 'Tugas Kalkulus...',
                                    ),
                                    validator: (value) {
                                      if (value == '') {
                                        return 'Tugas apa nih...';
                                      }
                                    },
                                    onSaved: (newValue) =>
                                        title.value = newValue!,
                                  ),
                                  SizedBox(height: 14.0),
                                  Text(
                                    'Deskripsi',
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  SizedBox(height: 14.0),
                                  TextFormField(
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      labelText: 'Halaman 3...',
                                      alignLabelWithHint: true,
                                    ),
                                    minLines: 8,
                                    maxLines: 20,
                                    onSaved: (newValue) =>
                                        description.value = newValue!,
                                  ),
                                  SizedBox(height: 14.0),
                                  Text(
                                    'Deadline',
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  SizedBox(height: 14.0),
                                  DateTimePicker(
                                    type: DateTimePickerType.dateTime,
                                    initialValue: '',
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                    dateLabelText: "Tanggal",
                                    timeLabelText: "Jam",
                                    initialTime: TimeOfDay(hour: 0, minute: 0),
                                    validator: (val) {
                                      if (val != null && val != '') {
                                        if (DateTime.parse(val)
                                            .isBefore(DateTime.now())) {
                                          return 'Yah tanggal & jam ini udah lewat...';
                                        }
                                      }

                                      return null;
                                    },
                                    onSaved: (newValue) =>
                                        deadline.value = newValue!,
                                    icon: Icon(Icons.today),
                                  ),
                                  SizedBox(height: 14.0),
                                  Text(
                                    'Lampiran',
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  SizedBox(height: 14.0),
                                  AttachmentsPicker(
                                    onChanges: (files) {
                                      attachments.value = files;
                                    },
                                  ),
                                  SizedBox(height: 14.0),
                                  Container(
                                    width: double.infinity,
                                    child: TextButton(
                                      onPressed: () async {
                                        clearFocus(context);

                                        if (!formKey.currentState!.validate()) {
                                          return;
                                        }

                                        formKey.currentState!.save();

                                        await context
                                            .read(subjectAssignmentsProvider
                                                .notifier)
                                            .addAssignment(
                                              title: title.value,
                                              description: description.value,
                                              deadline: deadline.value,
                                              attachmentFiles:
                                                  attachments.value,
                                            );

                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Simpan',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            ),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 14.0),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }
}
