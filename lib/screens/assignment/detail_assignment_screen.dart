import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/assignment/subject_assignments_provider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:bukutugas/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class DetailAssignmentScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final Assignment? assignment =
        useProvider(selectedAssignmentProvider).state;

    return Scaffold(
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      body: SafeArea(
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
                              borderRadius: BorderRadius.circular(24.0),
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
                                  color: Theme.of(context).backgroundColor,
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
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                          ),
                          Container(
                            // 14 ukuran chevron
                            padding: const EdgeInsets.all(24.0 + 14.0),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (assignment?.deadline != null &&
                              assignment!.deadline != '')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          DateFormat('EEEE, d MMMM', 'id_ID')
                                              .format(
                                            DateTime.parse(
                                                assignment.deadline!),
                                          ),
                                        ),
                                        Text(
                                          DateFormat('H:m', 'id_ID').format(
                                            DateTime.parse(
                                                assignment.deadline!),
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(
                                                color: Theme.of(context)
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
                                      DateTime.parse(assignment.deadline!),
                                      allowFromNow: true,
                                      locale: 'id',
                                    ),
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              ],
                            ),
                          Text(
                            assignment?.title ?? '-',
                            style:
                                Theme.of(context).textTheme.headline1!.copyWith(
                                      color: Theme.of(context).backgroundColor,
                                    ),
                          ),
                          SizedBox(height: 14),
                          DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 1.0,
                            dashLength: 4.0,
                            dashColor: Theme.of(context)
                                .backgroundColor
                                .withOpacity(0.5),
                            dashRadius: 1,
                            dashGapLength: 4.0,
                            dashGapColor: Colors.transparent,
                            dashGapRadius: 0.0,
                          ),
                          SizedBox(height: 24),
                          Text(assignment?.description ?? '-'),
                          SizedBox(height: 14),
                          // TODO: implement attachments
                          // ignore: dead_code
                          if (false) ...[
                            Text(
                              'Lampiran',
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            SizedBox(height: 14.0),
                            AttachmentList(),
                          ]
                        ],
                      ),
                    ),
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

                      context
                          .read(subjectAssignmentsProvider.notifier)
                          .deleteAssignment(assignment: assignment);

                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red[300],
                      size:
                          Theme.of(context).textTheme.headline4!.fontSize! + 4,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (assignment == null ||
                            assignment.status == AssignmentStatus.done) return;

                        context
                            .read(subjectAssignmentsProvider.notifier)
                            .markAssignmentStatusAs(
                                assignment: assignment,
                                status: AssignmentStatus.done);

                        context.read(selectedAssignmentProvider).state =
                            assignment..status = AssignmentStatus.done;
                      },
                      child: Text(
                        assignment?.status != AssignmentStatus.done
                            ? 'Selesai'
                            : 'Sudah Selesai',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Theme.of(context).primaryColorLight,
                            ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            assignment?.status != AssignmentStatus.done
                                ? Theme.of(context).accentColor
                                : Theme.of(context).shadowColor,
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
          ],
        ),
      ),
    );
  }
}
