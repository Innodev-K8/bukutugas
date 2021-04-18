import 'package:bukutugas/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final availableColorProvider = Provider<List<Color>>((ref) {
  return [
    HexColor('#F8A488'),
    HexColor('#5AA897'),
    HexColor('#45526C'),
    HexColor('#707070'),
  ];
});
