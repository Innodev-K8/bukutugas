import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/assignment/assignment_list_provider.dart';
import 'package:bukutugas/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:bukutugas/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
                            padding: const EdgeInsets.all(24.0),
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
                          Text(
                            assignment?.deadline ?? '-',
                            style:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                    ),
                          ),
                          Text(
                            assignment?.title ?? '-',
                            style:
                                Theme.of(context).textTheme.headline1!.copyWith(
                                      color: AppTheme.orange,
                                    ),
                          ),
                          SizedBox(height: 14),
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
                  InkWell(
                    onTap: () {
                      if (assignment == null) return;

                      context
                          .read(assignmentListProvider.notifier)
                          .deleteAssignment(assignment: assignment);

                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Icon(
                        Icons.delete,
                        color: Colors.red[300],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (assignment == null || assignment.status == 'done')
                          return;

                        final updatedAssignment = assignment..status = 'done';

                        context
                            .read(assignmentListProvider.notifier)
                            .updateAssignment(
                              updatedAssignment: updatedAssignment,
                            );

                        context.read(selectedAssignmentProvider).state =
                            updatedAssignment;
                      },
                      child: Text(
                        assignment?.status != 'done'
                            ? 'Selesai'
                            : 'Sudah Selesai',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Theme.of(context).primaryColorLight,
                            ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: assignment?.status != 'done'
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
