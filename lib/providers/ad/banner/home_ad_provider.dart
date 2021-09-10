import 'package:bukutugas/providers/ad/banner_ad_listener_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final homeAdProvider = Provider<BannerAd>((ref) {
  return BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: AdRequest(),
      listener: ref.read(bannerAdListenerProvider))
    ..load();
});
