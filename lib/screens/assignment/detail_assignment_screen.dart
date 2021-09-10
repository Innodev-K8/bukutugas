import 'package:bukutugas/helpers/helpers.dart';
import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/ad/banner/assignment_ad_provider.dart';
import 'package:bukutugas/providers/assignment/subject_assignments_provider.dart';
import 'package:bukutugas/screens/assignment/create_assignment_screen.dart';
import 'package:bukutugas/styles.dart';
import 'package:bukutugas/widgets/banner_ad_widget.dart';
import 'package:bukutugas/widgets/dottted_separator.dart';
import 'package:bukutugas/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class DetailAssignmentScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final Assignment? assignment =
        useProvider(selectedAssignmentProvider).state;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Column(
        children: [
          Expanded(
            child: Scaffold(
              backgroundColor:
                  Theme.of(context).bottomSheetTheme.backgroundColor,
              body: SafeArea(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    clearFocus(context);
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 28 + 24 * 2,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.chevron_left,
                                            color: Theme.of(context)
                                                .backgroundColor,
                                            size: 28.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          assignment?.title ?? '-',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateAssignmentScreen(
                                                isEdit: true,
                                                assignment: assignment,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.edit_rounded,
                                            color:
                                                Theme.of(context).accentColor,
                                            size: 22.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (assignment?.deadline != null &&
                                        assignment!.deadline != '')
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.today_outlined,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline2!
                                                    .color!
                                                    .withOpacity(0.8),
                                                size: 22.0,
                                              ),
                                              SizedBox(width: 8),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    DateFormat('EEEE, d MMMM',
                                                            'id_ID')
                                                        .format(
                                                      DateTime.parse(
                                                          assignment.deadline!),
                                                    ),
                                                  ),
                                                  Text(
                                                    DateFormat('HH:mm', 'id_ID')
                                                        .format(
                                                      DateTime.parse(
                                                          assignment.deadline!),
                                                    ),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5!
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText2!
                                                                  .color,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Chip(
                                            backgroundColor:
                                                Theme.of(context).accentColor,
                                            label: Text(
                                              timeago.format(
                                                DateTime.parse(
                                                    assignment.deadline!),
                                                allowFromNow: true,
                                                locale: 'id',
                                              ),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    SelectableText(
                                      assignment?.title ?? '-',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .backgroundColor,
                                          ),
                                    ),
                                    SizedBox(height: 14),
                                    DottedSeparator(),
                                    SizedBox(height: 24),
                                    SelectableLinkify(
                                      onOpen: (link) async {
                                        if (await canLaunch(link.url)) {
                                          await launch(link.url);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Tautan tidak dapat dibuka'),
                                            ),
                                          );
                                        }
                                      },
                                      text: assignment?.description ?? '-',
                                      linkStyle: TextStyle(
                                        color: AppTheme.green,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    if (assignment?.attachments != null &&
                                        assignment!.attachments!.length >
                                            0) ...[
                                      Text(
                                        'Foto',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      ),
                                      SizedBox(height: 14.0),
                                      AttachmentList(
                                        attachmentsUrl: assignment.attachments!,
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                              SizedBox(height: 14),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 14.0,
                        ),
                        width: double.infinity,
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                if (assignment == null) return;

                                // handle assignment delete
                                // handle subject delete
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Yakin mau dihapus?',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      ),
                                      insetPadding: const EdgeInsets.all(24.0),
                                      actionsPadding: const EdgeInsets.only(
                                        bottom: 7.0,
                                        right: 14.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: AppTheme.roundedLg,
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(
                                              'Mapel yang sudah dihapus tidak bisa dikembalikan lagi.',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                Theme.of(context).accentColor,
                                          ),
                                          child: Text(
                                            'Gajadi ah',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4!
                                                .copyWith(
                                                  color: Colors.white,
                                                ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.red[400],
                                          ),
                                          child: Text(
                                            'Yakin',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4!
                                                .copyWith(
                                                  color: Colors.white,
                                                ),
                                          ),
                                          onPressed: () {
                                            context
                                                .read(subjectAssignmentsProvider
                                                    .notifier)
                                                .deleteAssignment(
                                                    assignment: assignment);

                                            // close the dialog
                                            Navigator.of(context).pop();

                                            // exit the screen
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).primaryColorLight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                              ),
                              child: Icon(
                                Icons.delete,
                                color: Colors.red[300],
                                size: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .fontSize! +
                                    4,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: assignment?.status != AssignmentStatus.done
                                  ? _buildMarkDoneButton(assignment, context)
                                  : _buildMarkTodoButton(assignment, context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          BannerAdWidget(adProvider: assignmentAdProvider),
        ],
      ),
    );
  }

  TextButton _buildMarkDoneButton(
      Assignment? assignment, BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (assignment == null || assignment.status == AssignmentStatus.done)
          return;

        await context
            .read(subjectAssignmentsProvider.notifier)
            .markAssignmentStatusAs(
                assignment: assignment, status: AssignmentStatus.done);

        context.read(selectedAssignmentProvider).state = assignment
          ..status = AssignmentStatus.done;

        showAnimatedDialog(
          context: context,
          animationType: DialogTransitionType.scale,
          duration: Duration(milliseconds: 1200),
          curve: Curves.easeInOutBack,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Yeay selesai!',
                style: Theme.of(context).textTheme.headline2,
              ),
              insetPadding: const EdgeInsets.all(24.0),
              actionsPadding: const EdgeInsets.only(
                bottom: 7.0,
                right: 14.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.roundedLg,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'Selamat ya tugasnya udah selesai 😊',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                  child: Text(
                    'Yeay!',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Text(
        'Selesai',
        style: Theme.of(context).textTheme.headline4!.copyWith(
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
    );
  }

  TextButton _buildMarkTodoButton(
      Assignment? assignment, BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (assignment == null || assignment.status == AssignmentStatus.todo)
          return;

        await context
            .read(subjectAssignmentsProvider.notifier)
            .markAssignmentStatusAs(
                assignment: assignment, status: AssignmentStatus.todo);

        context.read(selectedAssignmentProvider).state = assignment
          ..status = AssignmentStatus.todo;

        showAnimatedDialog(
          context: context,
          animationType: DialogTransitionType.scale,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Kenapa nihh',
                style: Theme.of(context).textTheme.headline2,
              ),
              insetPadding: const EdgeInsets.all(24.0),
              actionsPadding: const EdgeInsets.only(
                bottom: 7.0,
                right: 14.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.roundedLg,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'Kenapapun itu tetap semangat ngerjainya yaa! 💪',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                  child: Text(
                    'Semangat!',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Text(
        'Eh Belum Selesai..',
        style: Theme.of(context).textTheme.headline4!.copyWith(
              color: Theme.of(context).primaryColorLight,
            ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
      ),
    );
  }
}
