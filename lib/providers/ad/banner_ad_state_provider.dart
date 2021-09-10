import 'package:hooks_riverpod/hooks_riverpod.dart';

enum BannerAdState { loading, loaded, failedToLoad }

final bannerAdStateProvider =
    StateProvider.family<BannerAdState, String>((ref, adUnitId) {
  return BannerAdState.loading;
});
