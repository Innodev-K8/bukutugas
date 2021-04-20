import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/auth/auth_controller.dart';
import 'package:bukutugas/providers/subject/subject_list_provider.dart';
import 'package:bukutugas/repositories/custom_exception.dart';
import 'package:bukutugas/repositories/subject_assignment_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum AssignmentListFilter { all, todo, done }

final assignmentListExceptionProvider =
    StateProvider<CustomException?>((_) => null);

final assignmentListProvider =
    StateNotifierProvider<AssignmentListNotifier, AsyncValue<List<Assignment>>>(
        (ref) {
  final user = ref.watch(userProvider);
  final subject = ref.watch(selectedSubjectProvider).state;

  return AssignmentListNotifier(ref.read, user?.uid, subject?.id);
});

final selectedAssignmentProvider = StateProvider<Assignment?>((_) => null);

final assignmentListFilterProvider = StateProvider<AssignmentListFilter>((_) {
  return AssignmentListFilter.todo;
});

final filteredAssignmentListProvider = Provider<List<Assignment>>((ref) {
  final assignmentList = ref.watch(assignmentListProvider);
  final assignmentListFilter = ref.watch(assignmentListFilterProvider).state;

  return assignmentList.maybeWhen(
    data: (assignments) {
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

class AssignmentListNotifier
    extends StateNotifier<AsyncValue<List<Assignment>>> {
  final Reader _read;
  final String? _userId;
  final String? _subjectId;

  AssignmentListNotifier(this._read, this._userId, this._subjectId)
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
    } on CustomException catch (e) {
      _read(assignmentListExceptionProvider).state = e;
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
    } on CustomException catch (e) {
      _read(assignmentListExceptionProvider).state = e;
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
    } on CustomException catch (e) {
      _read(assignmentListExceptionProvider).state = e;
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
          for (final assignment in assignments)
            if (assignment.id == assignment.id)
              assignment..status = status
            else
              assignment
        ]);
      });

      // update to get new count
      _read(subjectListProvider.notifier).retrieveItems();
    } on CustomException catch (e) {
      _read(assignmentListExceptionProvider).state = e;
    }
  }
}
