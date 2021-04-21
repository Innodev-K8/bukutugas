import 'package:bukutugas/helpers/helpers.dart';
import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/assignment/subject_assignments_provider.dart';
import 'package:bukutugas/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SimpleTask extends HookWidget {
  final Assignment assignment;

  const SimpleTask({Key? key, required this.assignment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOnTap = useState(false);

    return Container(
      height: 110 + 4,
      width: 290,
      child: Stack(
        children: [
          Positioned.fill(
            top: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: AppTheme.roundedLg,
                color: darken(Theme.of(context).primaryColorLight),
              ),
            ),
          ),
          AnimatedPositioned(
            top: isOnTap.value ? 4 : 0,
            left: 0,
            right: 0,
            duration: Duration(milliseconds: 100),
            child: Material(
              color: Theme.of(context).primaryColorLight,
              borderRadius: AppTheme.roundedLg,
              child: InkWell(
                onTapDown: (a) {
                  isOnTap.value = true;
                },
                onTapCancel: () {
                  isOnTap.value = false;
                },
                onTap: () {
                  isOnTap.value = false;

                  context.read(selectedAssignmentProvider).state = assignment;

                  Navigator.of(context).pushNamed('/assignment/detail');
                },
                borderRadius: AppTheme.roundedLg,
                child: Container(
                  height: 110 - 4,
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (assignment.deadline != null &&
                          assignment.deadline != '')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateTime.parse(assignment.deadline!)
                                          .difference(DateTime.now())
                                          .inHours <
                                      12
                                  ? DateFormat('H:m', 'id_ID').format(
                                      DateTime.parse(assignment.deadline!),
                                    )
                                  : DateFormat('E, d MMM', 'id_ID').format(
                                      DateTime.parse(assignment.deadline!),
                                    ),
                            ),
                            Text(
                              timeago.format(
                                DateTime.parse(assignment.deadline!),
                                allowFromNow: true,
                                locale: 'id',
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              assignment.title ?? '-',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            Text(
                              'ini deskripsi yang sangat panjang sekali broo.......',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                            // Text(assignment.description ?? '-'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
