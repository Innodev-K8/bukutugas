import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/assignment/all_assignments_provider.dart';
import 'package:bukutugas/providers/auth/auth_controller.dart';
import 'package:bukutugas/providers/subject/subject_list_provider.dart';
import 'package:bukutugas/repositories/custom_exception.dart';
import 'package:bukutugas/repositories/subject_assignment_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum AssignmentListFilter { all, todo, done }

final subjectAssignmentsExceptionProvider =
    StateProvider<CustomException?>((_) => null);

final subjectAssignmentsProvider = StateNotifierProvider<
    SubjectAssignmentsNotifier, AsyncValue<List<Assignment>>>((ref) {
  final user = ref.watch(userProvider);
  final subject = ref.watch(selectedSubjectProvider).state;

  return SubjectAssignmentsNotifier(ref.read, user?.uid, subject?.id);
});

final selectedAssignmentProvider = StateProvider<Assignment?>((_) => null);

final subjectAssignmentsFilterProvider =
    StateProvider<AssignmentListFilter>((_) {
  return AssignmentListFilter.todo;
});

final filteredAssignmentListProvider = Provider<List<Assignment>>((ref) {
  final assignmentList = ref.watch(subjectAssignmentsProvider);
  final assignmentListFilter =
      ref.watch(subjectAssignmentsFilterProvider).state;

  return assignmentList.maybeWhen(
    data: (assignments) {
      final withDeadlines = assignments
          .where(
            (assignment) =>
                assignment.deadline != null && assignment.deadline != '',
          )
          .toList();

      final withoutDeadlines = assignments
          .where(
            (assignment) =>
                assignment.deadline == null || assignment.deadline == '',
          )
          .toList();

      // sort
      withDeadlines.sort((a, b) {
        return DateTime.parse(a.deadline!).compareTo(
          DateTime.parse(b.deadline!),
        );
      });

      // combine
      assignments = [...withDeadlines, ...withoutDeadlines];

      switch (assignmentListFilter) {
        case AssignmentListFilter.todo:
          return assignments
              .where((assignment) => assignment.status == AssignmentStatus.todo)
              .toList();
        case AssignmentListFilter.done:
          return assignments
              .where((assignment) => assignment.status == AssignmentStatus.done)
              .toList();
        case AssignmentListFilter.all:
          return assignments;
      }
    },
    orElse: () => [],
  );
});

class SubjectAssignmentsNotifier
    extends StateNotifier<AsyncValue<List<Assignment>>> {
  final Reader _read;
  final String? _userId;
  final String? _subjectId;

  SubjectAssignmentsNotifier(this._read, this._userId, this._subjectId)
      : super(AsyncValue.loading()) {
    retrieveItems();
  }

  Future<void> retrieveItems({bool isRefreshing = false}) async {
    if (isRefreshing) state = AsyncValue.loading();

    try {
      final assignments = await _read(subjectAssignmentRepositoryProvider)
          .retrieveItems(userId: _userId!, subjectId: _subjectId!);

      if (mounted) {
        state = AsyncValue.data(assignments);
      }
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addAssignment({
    required String title,
    String description = '',
    String deadline = '',
  }) async {
    try {
      final assignment = Assignment(
        title: title,
        description: description,
        deadline: deadline,
        attachments: [],
      );

      final assignmentId = await _read(subjectAssignmentRepositoryProvider)
          .createAssignment(
              userId: _userId!, subjectId: _subjectId!, assignment: assignment);

      state.whenData((assignments) {
        state =
            AsyncValue.data([...assignments, assignment..id = assignmentId]);
      });

      // update to get new count
      _read(subjectListProvider.notifier).retrieveItems();
      _read(allAssignmentsProvider.notifier).retrieveItems();
    } on CustomException catch (e) {
      _read(subjectAssignmentsExceptionProvider).state = e;
    }
  }

  Future<void> updateAssignment({required Assignment updatedAssignment}) async {
    try {
      await _read(subjectAssignmentRepositoryProvider).updateAssignment(
          userId: _userId!,
          subjectId: _subjectId!,
          assignment: updatedAssignment);

      state.whenData((assignments) {
        state = AsyncValue.data([
          for (final assignment in assignments)
            if (assignment.id == updatedAssignment.id)
              updatedAssignment
            else
              assignment
        ]);
      });

      _read(allAssignmentsProvider.notifier).retrieveItems();
    } on CustomException catch (e) {
      _read(subjectAssignmentsExceptionProvider).state = e;
    }
  }

  Future<void> deleteAssignment({required Assignment assignment}) async {
    try {
      await _read(subjectAssignmentRepositoryProvider).deleteAssignment(
          userId: _userId!, subjectId: _subjectId!, assignment: assignment);

      state.whenData((assignments) {
        state = AsyncValue.data(assignments
          ..removeWhere((_assignment) => _assignment.id == assignment.id));
      });

      // update to get new count
      _read(subjectListProvider.notifier).retrieveItems();
      _read(allAssignmentsProvider.notifier).retrieveItems();
    } on CustomException catch (e) {
      _read(subjectAssignmentsExceptionProvider).state = e;
    }
  }

  Future<void> markAssignmentStatusAs(
      {required Assignment assignment,
      required AssignmentStatus status}) async {
    try {
      await _read(subjectAssignmentRepositoryProvider).markAssignmentStatusAs(
        userId: _userId!,
        subjectId: _subjectId!,
        assignment: assignment,
        status: status,
      );

      state.whenData((assignments) {
        state = AsyncValue.data([
          for (final currentAssignment in assignments)
            if (assignment.id == currentAssignment.id)
              assignment..status = status
            else
              currentAssignment
        ]);
      });

      // update to get new count
      _read(subjectListProvider.notifier).retrieveItems();
      _read(allAssignmentsProvider.notifier).retrieveItems();
    } on CustomException catch (e) {
      _read(subjectAssignmentsExceptionProvider).state = e;
    }
  }
}
