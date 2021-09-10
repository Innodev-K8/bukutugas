import 'package:bukutugas/providers/ad/banner_ad_state_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bannerAdListenerProvider = Provider<BannerAdListener>((ref) {
  return BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => {
      ref.read(bannerAdStateProvider(ad.adUnitId)).state = BannerAdState.loaded,
    },
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();

      ref.read(bannerAdStateProvider(ad.adUnitId)).state =
          BannerAdState.failedToLoad;
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );
});
