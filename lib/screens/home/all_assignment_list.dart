import 'package:bukutugas/providers/assignment/all_assignments_provider.dart';
import 'package:bukutugas/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AllAssignmentList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final assignmentsProvider = useProvider(allAssignmentsProvider);

    return assignmentsProvider.data?.value.isEmpty ?? false
        ? SizedBox.shrink()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 24.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_none_outlined,
                      color: Theme.of(context).textTheme.headline2!.color,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Tugas',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ],
                ),
              ),
              Container(
                height: 110,
                child: assignmentsProvider.when(
                  data: (assignments) => assignments.isEmpty
                      ? Text('kosong')
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          itemCount: assignments.length,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 14.0),
                          itemBuilder: (context, index) => SimpleTask(
                            assignment: assignments[index],
                          ),
                        ),
                  error: (e, st) => Text(e.toString()),
                  loading: () => Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          );
  }
}
