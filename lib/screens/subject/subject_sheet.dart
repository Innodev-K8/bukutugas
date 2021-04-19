import 'package:bukutugas/providers/assignment/assignment_list_provider.dart';
import 'package:bukutugas/widgets/assignment_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubjectSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tugas',
                style: Theme.of(context).textTheme.headline2,
              ),
              AssignmentFilterSelector()
            ],
          ),
        ),
        Consumer(
          builder: (context, watch, child) {
            final assignmentProvider = watch(assignmentListProvider);
            final filteredAssignmentList =
                watch(filteredAssignmentListProvider);

            return assignmentProvider.when(
              data: (assignments) => filteredAssignmentList.isEmpty
                  ? EmptyAssignment()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredAssignmentList.length,
                      scrollDirection: Axis.vertical,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 14.0),
                      itemBuilder: (context, index) => AssignmentItem(
                        assignment: filteredAssignmentList[index],
                      ),
                    ),
              error: (e, st) => Text(e.toString()),
              loading: () => Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class AssignmentFilterSelector extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final filterState = useProvider(assignmentListFilterProvider).state;

    return Container(
      child: Wrap(
        spacing: 8.0,
        children: [
          Tooltip(
            message: "Belum Selesai",
            child: GestureDetector(
              onTap: () {
                context.read(assignmentListFilterProvider).state =
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
                context.read(assignmentListFilterProvider).state =
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
                context.read(assignmentListFilterProvider).state =
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
