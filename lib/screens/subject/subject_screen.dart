import 'package:bukutugas/helpers/helpers.dart';
import 'package:bukutugas/models/subject.dart';
import 'package:bukutugas/providers/assignment/subject_assignments_provider.dart';
import 'package:bukutugas/providers/subject/subject_list_provider.dart';
import 'package:bukutugas/screens/subject/subject_sheet.dart';
import 'package:bukutugas/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './subject_header.dart';

class SubjectScreen extends HookWidget {
  final _headerHeight = 280.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bodySizeFactor = 1 - (_headerHeight / size.height);

    final Subject? subject = useProvider(selectedSubjectProvider).state;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: subject?.color != null
            ? HexColor(subject!.color!)
            : Theme.of(context).backgroundColor,
        body: Stack(
          children: [
            Container(
              height: _headerHeight,
              child: SubjectHeader(),
            ),
            DraggableScrollableSheet(
              initialChildSize: bodySizeFactor,
              minChildSize: bodySizeFactor,
              // 1 - (Tinggi Header + Paddingnya SafeArea)
              maxChildSize: 1 -
                  ((MediaQuery.of(context).padding.top + 28 + 24 * 2) /
                      size.height),
              builder: (context, scrollController) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dialogBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: SubjectSheet(),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
        floatingActionButton: _buildFab(context),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final filter = watch(subjectAssignmentsFilterProvider).state;

        return Container(
          width: 56,
          height: 56,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 250),
            transitionBuilder: (switchedChild, animation) {
              final curvedAnimation =
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut);

              return SlideTransition(
                position: curvedAnimation.drive(
                  Tween<Offset>(
                    begin: Offset(0, 1.5),
                    end: Offset(0, 0),
                  ),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // to fix list jumps after transition, set minHeght equal to EmptySubject()
                    minHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: switchedChild,
                ),
              );
            },
            child:
                filter == AssignmentListFilter.todo ? child : SizedBox.shrink(),
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/assignment/create');
        },
        elevation: 6,
        child: const Icon(Icons.edit_rounded),
        backgroundColor: darken(AppTheme.green),
      ),
    );
  }
}
