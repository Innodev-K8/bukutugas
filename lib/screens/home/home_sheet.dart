import 'package:bukutugas/providers/subject/subject_list_provider.dart';
import 'package:flutter/material.dart';

import 'package:bukutugas/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeSheet extends StatelessWidget {
  const HomeSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
        //   child: Text(
        //     'Tugas',
        //     style: Theme.of(context).textTheme.headline2,
        //   ),
        // ),
        // Container(
        //   height: 157,
        //   padding: const EdgeInsets.only(bottom: 7.0),
        //   child: ListView.separated(
        //     padding: const EdgeInsets.symmetric(horizontal: 24.0),
        //     itemCount: 10,
        //     scrollDirection: Axis.horizontal,
        //     separatorBuilder: (context, index) => SizedBox(width: 16.0),
        //     itemBuilder: (context, index) => SimpleTask(),
        //   ),
        // ),
        SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
          child: Text(
            'Mapel',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        Consumer(builder: (context, watch, child) {
          final subjectsProvider = watch(subjectListProvider);

          return subjectsProvider.when(
            data: (subjects) => subjects.isEmpty
                // TODO: draw arrow on empty
                ? Text('Tambahkan Subject')
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: subjects.length,
                    scrollDirection: Axis.vertical,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 14.0),
                    itemBuilder: (context, index) => SubjectItem(
                      subject: subjects[index],
                    ),
                  ),
            error: (e, st) => Text(e.toString()),
            loading: () => Center(
              child: CircularProgressIndicator(),
            ),
          );
        }),
      ],
    );
  }
}
