import 'package:bukutugas/providers/firebase_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Analytic {
  Reader _reader;

  Analytic(this._reader);

  void logLogin() {
    _reader(firebaseAnalyticsProvider).logLogin();
  }

  void logLogout() {
    _reader(firebaseAnalyticsProvider).logEvent(name: 'logout');
  }

  void logSubjectCreate() {
    _reader(firebaseAnalyticsProvider).logEvent(name: 'subject_create');
  }

  void logSubjectUpdate() {
    _reader(firebaseAnalyticsProvider).logEvent(name: 'subject_update');
  }

  void logSubjectDelete() {
    _reader(firebaseAnalyticsProvider).logEvent(name: 'subject_delete');
  }

  void logAssignmentCreate() {
    _reader(firebaseAnalyticsProvider).logEvent(name: 'assignment_create');
  }

  void logAssignmentUpdate() {
    _reader(firebaseAnalyticsProvider).logEvent(name: 'assignment_update');
  }

  void logAssignmentDelete() {
    _reader(firebaseAnalyticsProvider).logEvent(name: 'assignment_delete');
  }
}

final analyticProvider = Provider<Analytic>((ref) {
  return Analytic(ref.read);
});
