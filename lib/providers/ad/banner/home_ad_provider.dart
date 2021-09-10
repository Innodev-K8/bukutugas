import 'package:bukutugas/providers/ad/ad_unit_ids.dart';
import 'package:bukutugas/providers/ad/banner_ad_listener_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final homeAdProvider = Provider<BannerAd>((ref) {
  return BannerAd(
      adUnitId: AdUnitIds.homeAd,
      size: AdSize.banner,
      request: AdRequest(),
      listener: ref.read(bannerAdListenerProvider))
    ..load();
});
