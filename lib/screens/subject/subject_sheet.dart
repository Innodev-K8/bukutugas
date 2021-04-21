import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/assignment/subject_assignments_provider.dart';
import 'package:bukutugas/widgets/assignment_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';

class SubjectSheet extends HookWidget {
  final animationDuration = Duration(milliseconds: 350);

  @override
  Widget build(BuildContext context) {
    final assignmentProvider = useProvider(subjectAssignmentsProvider);
    final filteredAssignmentList = useProvider(filteredAssignmentListProvider);
    final assignmentListFilter =
        useProvider(subjectAssignmentsFilterProvider).state;

    String title;

    switch (assignmentListFilter) {
      case AssignmentListFilter.todo:
        title = 'Tugas';
        break;
      case AssignmentListFilter.done:
        title = 'Tugas Selesai';
        break;
      case AssignmentListFilter.all:
        title = 'Semua Tugas';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline2,
              ),
              AssignmentFilterSelector()
            ],
          ),
        ),
        assignmentProvider.when(
          data: (assignments) => filteredAssignmentList.isEmpty
              ? EmptyAssignment()
              : ImplicitlyAnimatedList<Assignment>(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  items: filteredAssignmentList,
                  areItemsTheSame: (a, b) => a.id == b.id,
                  scrollDirection: Axis.vertical,
                  insertDuration: animationDuration,
                  removeDuration: animationDuration,
                  itemBuilder: (context, animation, assignment, index) {
                    final curvedAnimation = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    );

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ScaleTransition(
                        scale: curvedAnimation
                          ..drive(
                            Tween(
                              begin: 0,
                              end: 1,
                            ),
                          ),
                        child: AssignmentItem(
                          assignment: assignment,
                        ),
                      ),
                    );
                  },
                  removeItemBuilder: (context, animation, removedAssignment) {
                    final curvedAnimation = CurvedAnimation(
                        parent: animation, curve: Curves.easeInOut);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ScaleTransition(
                        scale: curvedAnimation
                          ..drive(
                            Tween(
                              begin: 0,
                              end: 1,
                            ),
                          ),
                        child: AssignmentItem(
                          assignment: removedAssignment,
                        ),
                      ),
                    );
                  },
                ),
          error: (e, st) => Text(e.toString()),
          loading: () => Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    );
  }
}

class AssignmentFilterSelector extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final filterState = useProvider(subjectAssignmentsFilterProvider).state;

    return Container(
      child: Wrap(
        spacing: 8.0,
        children: [
          Tooltip(
            message: "Belum Selesai",
            child: GestureDetector(
              onTap: () {
                context.read(subjectAssignmentsFilterProvider).state =
                    AssignmentListFilter.todo;
              },
              child: Chip(
                backgroundColor: filterState == AssignmentListFilter.todo
                    ? Theme.of(context).accentColor
                    : Colors.transparent,
                label: Icon(
                  Icons.work,
                  color: filterState == AssignmentListFilter.todo
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).backgroundColor,
                  size: 18.0,
                ),
              ),
            ),
          ),
          Tooltip(
            message: "Selesai",
            child: GestureDetector(
              onTap: () {
                context.read(subjectAssignmentsFilterProvider).state =
                    AssignmentListFilter.done;
              },
              child: Chip(
                backgroundColor: filterState == AssignmentListFilter.done
                    ? Theme.of(context).accentColor
                    : Colors.transparent,
                // padding: const EdgeInsets.all(0),
                label: Icon(
                  Icons.done_all,
                  color: filterState == AssignmentListFilter.done
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).backgroundColor,
                  size: 18.0,
                ),
              ),
            ),
          ),
          Tooltip(
            message: "Semua",
            child: GestureDetector(
              onTap: () {
                context.read(subjectAssignmentsFilterProvider).state =
                    AssignmentListFilter.all;
              },
              child: Chip(
                backgroundColor: filterState == AssignmentListFilter.all
                    ? Theme.of(context).accentColor
                    : Colors.transparent,
                // padding: const EdgeInsets.all(0),
                label: Icon(
                  Icons.all_inbox,
                  color: filterState == AssignmentListFilter.all
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).backgroundColor,
                  size: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyAssignment extends StatelessWidget {
  const EmptyAssignment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_assignment.png',
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Yeay gaada tugas!',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
