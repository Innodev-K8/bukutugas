import 'dart:io';

import 'package:bukutugas/helpers/helpers.dart';
import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/assignment/subject_assignments_provider.dart';
import 'package:bukutugas/repositories/custom_exception.dart';
import 'package:bukutugas/screens/assignment/attachments_picker.dart';
import 'package:bukutugas/styles.dart';
import 'package:bukutugas/widgets/dottted_separator.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateAssignmentScreen extends HookWidget {
  final bool isEdit;
  final Assignment? assignment;

  CreateAssignmentScreen({this.isEdit = false, this.assignment})
      : assert(
          isEdit == false || assignment != null,
          'Assignment is required when is edit',
        );

  @override
  Widget build(BuildContext context) {
    final isUploadingAssignment =
        useProvider(isUploadingAssignmentProvider).state;

    final formKey = useMemoized(() => GlobalKey<FormState>());

    final title = useState<String>(isEdit ? assignment?.title ?? '' : '');
    final description =
        useState<String>(isEdit ? assignment?.description ?? '' : '');
    final deadline = useState<String>(isEdit ? assignment?.deadline ?? '' : '');
    final attachments = useState<List<File>>([]);
    final currentAttachments =
        useState<List<String>>(isEdit ? assignment?.attachments ?? [] : []);
    final deletedAttachments = useState<List<String>>([]);

    Future<void> saveAssignment() async {
      if (isEdit) {
        await _editAssignment(context, title, description, deadline,
            attachments, deletedAttachments);
      } else {
        await _createAssignment(
            context, title, description, deadline, attachments);
      }
    }

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
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    clearFocus(context);
                  },
                  child: SafeArea(
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(24.0),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(
                                      isEdit
                                          ? Icons.close_rounded
                                          : Icons.chevron_left,
                                      color: Theme.of(context).backgroundColor,
                                      size: 28.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      isEdit ? 'Edit Tugas' : 'Tambah Tugas',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(24.0),
                                    onTap: () async {
                                      if (!formKey.currentState!.validate()) {
                                        return;
                                      }

                                      formKey.currentState!.save();

                                      await saveAssignment();

                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: Theme.of(context).accentColor,
                                      size: 28.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Form(
                              key: formKey,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .copyWith(
                                            color: AppTheme.green,
                                          ),
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                        labelText: 'Judul',
                                        fillColor: Colors.transparent,
                                        contentPadding: const EdgeInsets.only(),
                                      ),
                                      autofocus: !isEdit,
                                      textInputAction: TextInputAction.next,
                                      initialValue: title.value,
                                      validator: (value) {
                                        if (value == '') {
                                          return 'Tugas apa nih...';
                                        }
                                      },
                                      onSaved: (newValue) =>
                                          title.value = newValue!,
                                    ),
                                    SizedBox(height: 14),
                                    DateTimePicker(
                                      type: DateTimePickerType.dateTime,
                                      initialValue: deadline.value,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100),
                                      dateLabelText: "Deadline",
                                      timeLabelText: "Jam",
                                      initialTime:
                                          TimeOfDay(hour: 0, minute: 0),
                                      onSaved: (newValue) =>
                                          deadline.value = newValue!,
                                      icon: Icon(Icons.today),
                                    ),
                                    SizedBox(height: 14.0),
                                    Text(
                                      'Lampiran Foto',
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                    SizedBox(height: 14.0),
                                    AttachmentsPicker(
                                      currentAttachments:
                                          currentAttachments.value,
                                      onChanges: (files) {
                                        attachments.value = files;
                                      },
                                      onCurrentAttachmentDeleted:
                                          (attachmentUrl) {
                                        deletedAttachments.value = [
                                          ...deletedAttachments.value,
                                          attachmentUrl
                                        ];
                                      },
                                    ),
                                    SizedBox(height: 14),
                                    DottedSeparator(),
                                    SizedBox(height: 24),
                                    TextFormField(
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                        labelText: 'Penjelasan tugas',
                                        alignLabelWithHint: true,
                                        fillColor: Colors.transparent,
                                        contentPadding: const EdgeInsets.only(),
                                      ),
                                      initialValue: description.value,
                                      minLines:
                                          MediaQuery.of(context).size.height *
                                              0.7 ~/
                                              34,
                                      maxLines: null,
                                      onSaved: (newValue) =>
                                          description.value = newValue!,
                                    ),
                                    SizedBox(height: 14.0),
                                    Container(
                                      width: double.infinity,
                                      child: TextButton(
                                        onPressed: () async {
                                          clearFocus(context);

                                          if (!formKey.currentState!
                                              .validate()) {
                                            return;
                                          }

                                          formKey.currentState!.save();

                                          await saveAssignment();

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
                  ),
                )),
    );
  }

  Future _createAssignment(
      BuildContext context,
      ValueNotifier<String> title,
      ValueNotifier<String> description,
      ValueNotifier<String> deadline,
      ValueNotifier<List<File>> attachments) async {
    await context.read(subjectAssignmentsProvider.notifier).addAssignment(
          title: title.value,
          description: description.value,
          deadline: deadline.value,
          attachmentFiles: attachments.value,
        );
  }

  Future _editAssignment(
      BuildContext context,
      ValueNotifier<String> title,
      ValueNotifier<String> description,
      ValueNotifier<String> deadline,
      ValueNotifier<List<File>> attachments,
      ValueNotifier<List<String>> deletedAttachments) async {
    final updatedAssignment = await context
        .read(subjectAssignmentsProvider.notifier)
        .updateAssignment(
          updatedAssignment: Assignment(
            // id, user id, subject id and current attachments is MUST and should not be edited directly!
            id: assignment?.id,
            userId: assignment?.userId,
            subjectId: assignment?.subjectId,
            attachments: assignment?.attachments,
            status: assignment?.status,

            // use new eddited value
            title: title.value,
            description: description.value,
            deadline: deadline.value,
          ),
          newAttachments: attachments.value,
          deletedAttachments: deletedAttachments.value,
        );

    if (updatedAssignment != null) {
      context.read(selectedAssignmentProvider).state = updatedAssignment;
    }
  }
}
