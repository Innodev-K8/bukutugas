import 'package:bukutugas/models/subject.dart';
import 'package:bukutugas/providers/subject/subject_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:bukutugas/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';

import 'all_assignment_list.dart';

class HomeSheet extends StatelessWidget {
  const HomeSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animationDuration = Duration(milliseconds: 1000);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AllAssignmentList(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
          child: Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: Theme.of(context).textTheme.headline2!.color,
              ),
              SizedBox(width: 8),
              Text(
                'Mapel',
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
        ),
        Consumer(builder: (context, watch, child) {
          final subjectsProvider = watch(subjectListProvider);

          return subjectsProvider.when(
            data: (subjects) => AnimatedSwitcher(
              duration: Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                final curvedAnimation =
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut);

                return ScaleTransition(
                  scale: curvedAnimation
                    ..drive(
                      Tween(
                        begin: 0,
                        end: 1,
                      ),
                    ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      // to fix list jumps after transition, set minHeght equal to EmptySubject()
                      minHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: child,
                  ),
                );
              },
              child: subjects.isEmpty
                  ? EmptySubject()
                  : ImplicitlyAnimatedList<Subject>(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      items: subjects,
                      areItemsTheSame: (a, b) => a.id == b.id,
                      scrollDirection: Axis.vertical,
                      insertDuration: animationDuration,
                      removeDuration: animationDuration,
                      itemBuilder: (context, animation, subject, index) {
                        final curvedAnimation = CurvedAnimation(
                          parent: animation,
                          curve: Curves.bounceOut,
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
                            child: SubjectItem(
                              subject: subject,
                            ),
                          ),
                        );
                      },
                      removeItemBuilder: (context, animation, removedSubject) {
                        final curvedAnimation = CurvedAnimation(
                            parent: animation, curve: Curves.easeInOutBack);

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
                            child: SubjectItem(
                              subject: removedSubject,
                            ),
                          ),
                        );
                      },
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

class EmptySubject extends StatelessWidget {
  const EmptySubject({
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
            'assets/images/empty_subject.png',
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Klik tombol di bawah buat nambah mapel',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
