import 'package:bukutugas/providers/ad/interstitial_ad_callback_provider.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final doneAssignmentAdProvider =
    StateNotifierProvider<DoneAssignmentAdNotifier, InterstitialAd?>((ref) {
  return DoneAssignmentAdNotifier(ref.read);
});

class DoneAssignmentAdNotifier extends StateNotifier<InterstitialAd?> {
  final Reader read;

  DoneAssignmentAdNotifier(this.read) : super(null) {
    final showAd = RemoteConfig.instance.getBool('show_ad');

    if (!showAd) return;

    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          state = ad;

          state!.fullScreenContentCallback =
              read(interstitialAdCallbackProvider);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }
}
