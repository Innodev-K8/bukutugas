import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/assignment/assignment_list_provider.dart';
import 'package:bukutugas/styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AssignmentItem extends StatelessWidget {
  final Assignment assignment;

  const AssignmentItem({
    Key? key,
    required this.assignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColorLight,
      borderRadius: AppTheme.roundedLg,
      child: InkWell(
        onTap: () {
          context.read(selectedAssignmentProvider).state = assignment;

          Navigator.of(context).pushNamed('/assignment/detail');
        },
        borderRadius: AppTheme.roundedLg,
        child: Container(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                assignment.title ?? '-',
                style: Theme.of(context).textTheme.headline2,
              ),
              if (assignment.deadline != null && assignment.deadline != '')
                Text(
                  'Deadline, ' + assignment.deadline!,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 12.0,
                      ),
                ),
              if (assignment.description != null &&
                  assignment.description != '') ...[
                SizedBox(height: 8),
                Text(
                  assignment.description!,
                ),
              ],
              // TODO: implement attachment upload
              // ignore: dead_code
              if (false) ...[
                SizedBox(height: 14),
                AttachmentList(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AttachmentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Wrap(
        children: [
          Container(
            width: constraints.maxWidth / 3,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(
                  'https://images.template.net/wp-content/uploads/2016/03/28101221/Project-initiation-document-template.jpg'),
            ),
          ),
          Container(
            width: constraints.maxWidth / 3,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(
                  'https://images.template.net/wp-content/uploads/2016/03/28101221/Project-initiation-document-template.jpg'),
            ),
          ),
          Container(
            width: constraints.maxWidth / 3,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(
                  'https://images.template.net/wp-content/uploads/2016/03/28101221/Project-initiation-document-template.jpg'),
            ),
          ),
          Container(
            width: constraints.maxWidth / 3,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(
                  'https://images.template.net/wp-content/uploads/2016/03/28101221/Project-initiation-document-template.jpg'),
            ),
          ),
        ],
      );
    });
  }
}
