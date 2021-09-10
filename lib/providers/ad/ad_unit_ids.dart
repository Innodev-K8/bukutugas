import 'package:flutter/foundation.dart';

class AdUnitIds {
  static String _banner(adUnitId) {
    return kDebugMode ? 'ca-app-pub-3940256099942544/6300978111' : adUnitId;
  }

  static String _interstitial(adUnitId) {
    return kDebugMode ? 'ca-app-pub-3940256099942544/1033173712' : adUnitId;
  }

  static get homeAd => _banner('ca-app-pub-2149763024462380/2913634146');
  static get subjectAd => _banner('ca-app-pub-2149763024462380/5887281842');
  static get assignmentAd => _banner('ca-app-pub-2149763024462380/3261118501');

  static get doneAssignmentAd =>
      _interstitial('ca-app-pub-2149763024462380/6513967802');
}
