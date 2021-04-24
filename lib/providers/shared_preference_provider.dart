import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// must be ovveriden
final sharedPreferenceProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});
