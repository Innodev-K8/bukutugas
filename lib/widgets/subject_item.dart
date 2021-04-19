import 'package:bukutugas/helpers/date.dart';
import 'package:bukutugas/helpers/helpers.dart';
import 'package:bukutugas/models/subject.dart';
import 'package:bukutugas/providers/subject/subject_list_provider.dart';
import 'package:bukutugas/screens/home/add_subject.dart';
import 'package:bukutugas/styles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum SubjectItemMenuAction { edit, delete }

class SubjectItem extends StatelessWidget {
  final Subject subject;

  const SubjectItem({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: subject.color != null
          ? HexColor(subject.color!)
          : Theme.of(context).accentColor,
      borderRadius: AppTheme.roundedLg,
      child: InkWell(
        onTap: () {
          context.read(selectedSubjectProvider).state = subject;

          Navigator.of(context).pushNamed('/subject');
        },
        borderRadius: AppTheme.roundedLg,
        child: Container(
          height: 120.0,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          subject.emoji ?? '❔',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subject.name ?? '-',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              Text(
                                subject.days
                                        ?.map((dayOfWeek) =>
                                            stringDays[dayOfWeek])
                                        .join(', ') ??
                                    '-',
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '3 Tugas',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          subject.teacher ?? '-',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 36,
                  height: 36,
                  child: PopupMenuButton(
                    child: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: SubjectItemMenuAction.edit,
                          child: Text('Edit'),
                        ),
                        PopupMenuItem(
                          value: SubjectItemMenuAction.delete,
                          child: Text('Hapus'),
                        )
                      ];
                    },
                    onSelected: (SubjectItemMenuAction action) {
                      switch (action) {
                        case SubjectItemMenuAction.edit:
                          showMaterialModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => SubjectBottomSheetDialog(
                              isEdit: true,
                              subject: subject,
                            ),
                          );
                          break;
                        case SubjectItemMenuAction.delete:
                          context
                              .read(subjectListProvider.notifier)
                              .deleteSubject(subject: subject);
                          break;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
