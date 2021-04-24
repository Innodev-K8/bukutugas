import 'package:bukutugas/models/assignment.dart';
import 'package:bukutugas/providers/auth/auth_controller.dart';
import 'package:bukutugas/providers/notification/notification_provider.dart';
import 'package:bukutugas/repositories/all_assignment_repository.dart';
import 'package:bukutugas/repositories/custom_exception.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final allAssignmentsExceptionProvider =
    StateProvider<CustomException?>((_) => null);

final allAssignmentsProvider =
    StateNotifierProvider<AllAssignmentsNotifier, AsyncValue<List<Assignment>>>(
        (ref) {
  final user = ref.watch(userProvider);

  return AllAssignmentsNotifier(ref.read, user?.uid);
});

final allAssignmentsListProvider = StateProvider<List<Assignment>>((ref) {
  final provider = ref.watch(allAssignmentsProvider);

  return provider.data?.value ?? [];
});

class AllAssignmentsNotifier
    extends StateNotifier<AsyncValue<List<Assignment>>> {
  final Reader _read;
  final String? _userId;

  AllAssignmentsNotifier(this._read, this._userId)
      : super(AsyncValue.loading()) {
    retrieveItems();
  }

  Future<void> retrieveItems({bool isRefreshing = false}) async {
    if (isRefreshing) state = AsyncValue.loading();

    try {
      final assignments = await _read(assignmentRepositoryProvider)
          .retrieveItems(userId: _userId!);

      assignments.sort((a, b) {
        if (a.deadline == null || a.deadline == '') {
          return 1;
        } else if (b.deadline == null || b.deadline == '') {
          return -1;
        }

        return DateTime.parse(a.deadline!).compareTo(
          DateTime.parse(b.deadline!),
        );
      });

      if (mounted) {
        state = AsyncValue.data(assignments);

        _read(notificationProvider).rescheduleAllNotifications();
      }
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
