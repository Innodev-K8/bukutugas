import 'package:bukutugas/helpers/helpers.dart';
import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/assignment/subject_assignments_provider.dart';
import 'package:bukutugas/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class AssignmentItem extends HookWidget {
  final Assignment assignment;

  const AssignmentItem({
    Key? key,
    required this.assignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOnTap = useState(false);

    return Stack(
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
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          margin: isOnTap.value
              ? const EdgeInsets.only(top: 4, bottom: 0)
              : const EdgeInsets.only(top: 0, bottom: 4),
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
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            assignment.title ?? '-',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              assignment.status == AssignmentStatus.done
                                  ? Icons.fastfood_outlined
                                  : Icons.ac_unit_rounded,
                              color: assignment.status == AssignmentStatus.done
                                  ? AppTheme.green
                                  : AppTheme.orange,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      assignment.description ?? '-',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      maxLines: assignment.attachments == null ||
                              assignment.attachments!.length <= 0
                          ? 20
                          : 10,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    SizedBox(height: 12),
                    AttachmentList(
                      attachmentsUrl: assignment.attachments ?? [],
                    ),
                    SizedBox(height: 12),
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
                                ? DateFormat('HH:mm', 'id_ID').format(
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AttachmentList extends StatelessWidget {
  final List<String> attachmentsUrl;

  const AttachmentList({Key? key, this.attachmentsUrl = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: double.infinity,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: attachmentsUrl
              .map(
                (attachment) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AttachmentImageFull(
                          url: attachment,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    // minus spacing
                    width: (constraints.maxWidth / 3) - 8,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 3),
                        blurRadius: 8.0,
                        color:
                            Theme.of(context).backgroundColor.withOpacity(0.1),
                      )
                    ]),
                    child: Hero(
                      tag: attachment,
                      child: ClipRRect(
                        borderRadius: AppTheme.rounded,
                        child: FadeInImage(
                          image: NetworkImage(attachment),
                          placeholder: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    });
  }
}

class AttachmentImageFull extends StatelessWidget {
  final String url;

  const AttachmentImageFull({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black.withOpacity(0.5),
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: GestureDetector(
          child: Hero(
            tag: url,
            child: PhotoView(
              imageProvider: NetworkImage(url),
            ),
          ),
        ),
      ),
    );
  }
}
