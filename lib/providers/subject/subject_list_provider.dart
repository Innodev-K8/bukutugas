import 'package:bukutugas/models/subject.dart';
import 'package:bukutugas/providers/auth/auth_controller.dart';
import 'package:bukutugas/repositories/custom_exception.dart';
import 'package:bukutugas/repositories/subject_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final subjectListExceptionProvider =
    StateProvider<CustomException?>((_) => null);

final subjectListProvider =
    StateNotifierProvider<SubjectListNotifier, AsyncValue<List<Subject>>>(
        (ref) {
  final user = ref.watch(userProvider);

  return SubjectListNotifier(ref.read, user?.uid);
});

final selectedSubjectProvider = StateProvider<Subject?>((_) => null);

class SubjectListNotifier extends StateNotifier<AsyncValue<List<Subject>>> {
  final Reader _read;
  final String? _userId;

  SubjectListNotifier(this._read, this._userId) : super(AsyncValue.loading()) {
    retrieveItems();
  }

  Future<void> retrieveItems({bool isRefreshing = false}) async {
    if (isRefreshing) state = AsyncValue.loading();

    try {
      final subjects = await _read(subjectRepositoryProvider)
          .retrieveItems(userId: _userId!);

      if (mounted) {
        state = AsyncValue.data(subjects);
      }
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addSubject(
      {required String name,
      required List<int> days,
      String teacher = '',
      String emoji = '',
      String color = ''}) async {
    try {
      final subject = Subject(
        name: name,
        days: days,
        teacher: teacher,
        emoji: emoji,
        color: color,
      );

      final subjectId = await _read(subjectRepositoryProvider)
          .createSubject(userId: _userId!, subject: subject);

      state.whenData((subjects) {
        state = AsyncValue.data([...subjects, subject..id = subjectId]);
      });
    } on CustomException catch (e) {
      _read(subjectListExceptionProvider).state = e;
    }
  }

  Future<void> updateSubject({required Subject updatedSubject}) async {
    try {
      await _read(subjectRepositoryProvider)
          .updateSubject(userId: _userId!, subject: updatedSubject);

      state.whenData((subjects) {
        state = AsyncValue.data([
          for (final subject in subjects)
            if (subject.id == updatedSubject.id) updatedSubject else subject
        ]);
      });
    } on CustomException catch (e) {
      _read(subjectListExceptionProvider).state = e;
    }
  }

  Future<void> deleteSubject({required Subject subject}) async {
    try {
      await _read(subjectRepositoryProvider)
          .deleteSubject(userId: _userId!, subject: subject);

      state.whenData((subjects) {
        state = AsyncValue.data(
            subjects..removeWhere((_subject) => _subject.id == subject.id));
      });
    } on CustomException catch (e) {
      _read(subjectListExceptionProvider).state = e;
    }
  }
}
