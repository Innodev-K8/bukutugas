import 'package:bukutugas/widgets/assignment_item.dart';
import 'package:flutter/material.dart';

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
        ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 10,
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) => SizedBox(height: 14.0),
          itemBuilder: (context, index) => AssignmentItem(),
        ),
      ],
    );
  }
}
