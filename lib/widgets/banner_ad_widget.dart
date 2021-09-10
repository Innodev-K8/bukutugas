import 'package:bukutugas/providers/ad/banner_ad_state_provider.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BannerAdWidget extends HookWidget {
  const BannerAdWidget({
    Key? key,
    required this.adProvider,
  }) : super(key: key);

  final Provider<BannerAd> adProvider;

  @override
  Widget build(BuildContext context) {
    final adBanner = useProvider(adProvider);
    final adBannerState =
        useProvider(bannerAdStateProvider(adBanner.adUnitId)).state;
    final bool showAd = RemoteConfig.instance.getBool('show_ad');

    if (showAd && adBannerState == BannerAdState.loaded) {
      return Container(
        alignment: Alignment.center,
        child: AdWidget(ad: adBanner),
        width: adBanner.size.width.toDouble(),
        height: adBanner.size.height.toDouble(),
      );
    } else {
      return SizedBox();
    }
  }
}
