import 'package:bukutugas/providers/assignment/assignment_list_provider.dart';
import 'package:bukutugas/widgets/assignment_item.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubjectSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
          child: Text(
            'Tugas',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        Consumer(
          builder: (context, watch, child) {
            final assignmentProvider = watch(assignmentListProvider);

            return assignmentProvider.when(
              data: (assignments) => assignments.isEmpty
                  ? Text('Tidak ada tugas, yeayyyy')
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: assignments.length,
                      scrollDirection: Axis.vertical,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 14.0),
                      itemBuilder: (context, index) => AssignmentItem(
                        assignment: assignments[index],
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
