import 'package:isittofu/data/android10.g.dart';
import 'package:isittofu/data/android15.g.dart';
import 'package:isittofu/data/android16.g.dart';
import 'package:isittofu/data/android17.g.dart';
import 'package:isittofu/data/android18.g.dart';
import 'package:isittofu/data/android19.g.dart';
import 'package:isittofu/data/android21.g.dart';
import 'package:isittofu/data/android23.g.dart';
import 'package:isittofu/data/android24.g.dart';
import 'package:isittofu/data/android26.g.dart';
import 'package:isittofu/data/android28.g.dart';
import 'package:isittofu/data/android29.g.dart';
import 'package:isittofu/data/android30.g.dart';
import 'package:isittofu/data/android31.g.dart';
import 'package:isittofu/data/android32.g.dart';
import 'package:isittofu/data/android33.g.dart';
import 'package:isittofu/data/android34.g.dart';
import 'package:isittofu/data/android35.g.dart';
import 'package:isittofu/data/common.dart' as common;

final List<RegExp> patterns = List.unmodifiable(<RegExp>[
  android10Pattern,
  android15Pattern,
  android16Pattern,
  android17Pattern,
  android18Pattern,
  android19Pattern,
  android21Pattern,
  android21Pattern, // Android 22 is same as Android 21
  android23Pattern,
  android24Pattern,
  android24Pattern, // Android 25 is same as Android 24
  android26Pattern,
  android26Pattern, // Android 27 is same as Android 26
  android28Pattern,
  android29Pattern,
  android30Pattern,
  android31Pattern,
  android32Pattern,
  android33Pattern,
  android34Pattern,
  android35Pattern,
]);

enum AndroidPlatform {
  android10,
  android15,
  android16,
  android17,
  android18,
  android19,
  android21,
  android22,
  android23,
  android24,
  android25,
  android26,
  android27,
  android28,
  android29,
  android30,
  android31,
  android32,
  android33,
  android34,
  android35,
}

// See https://source.android.com/setup/start/build-numbers
const Map<AndroidPlatform, String> sdkToVersion = {
  AndroidPlatform.android10: '2.3.3',
  AndroidPlatform.android15: '4.0.3',
  AndroidPlatform.android16: '4.1',
  AndroidPlatform.android17: '4.2',
  AndroidPlatform.android18: '4.3',
  AndroidPlatform.android19: '4.4',
  AndroidPlatform.android21: '5.0',
  AndroidPlatform.android22: '5.1',
  AndroidPlatform.android23: '6.0',
  AndroidPlatform.android24: '7.0',
  AndroidPlatform.android25: '7.1',
  AndroidPlatform.android26: '8.0',
  AndroidPlatform.android27: '8.1',
  AndroidPlatform.android28: '9',
  AndroidPlatform.android29: '10',
  AndroidPlatform.android30: '11',
  AndroidPlatform.android31: '12',
  AndroidPlatform.android32: '12L',
  AndroidPlatform.android33: '13',
  AndroidPlatform.android34: '14',
  AndroidPlatform.android35: '15',
};

// Android Studio 2024.1.1 (data updated May 1, 2024); previously at
// https://developer.android.com/about/dashboards
const List<double> distribution = [
  0.000, // 2.3.3
  0.000, // 4.0.3
  0.000, // 4.1
  0.000, // 4.2
  0.000, // 4.3
  0.003, // 4.4 (100%)
  0.001, // 5.0 (99.7%)
  0.008, // 5.1 (99.6%)
  0.014, // 6.0 (98.8%)
  0.010, // 7.0 (97.4%)
  0.010, // 7.1 (96.4%)
  0.015, // 8.0 (95.4%)
  0.043, // 8.1 (93.9%)
  0.084, // 9 (89.6%)
  0.136, // 10 (81.2%)
  0.190, // 11 (67.6%)
  0.147, // 12 (48.6%)
  0.000, // 12L
  0.209, // 13 (33.9%)
  0.130, // 14 (13.0%)
  0, // 15 not listed
];

final _allPlatformIndices =
    List.generate(AndroidPlatform.values.length, (i) => i);

final Map<int, List<int>> overrides = Map.unmodifiable(<int, List<int>>{
  // VARIATION SELECTORs do not have a glyph in Android fonts (it happens to
  // have one in some versions of Apple Color Emoji) but is supported
  for (var i = 0xfe00; i <= 0xfe0f; i++) i: _allPlatformIndices,
  // LINE FEED happens to have a glyph in Android 5+ but is supported in all
  0x000a: _allPlatformIndices,
});

String platformToVersionString(int platformIdx) =>
    sdkToVersion[AndroidPlatform.values[platformIdx]]!;

Iterable<int> supportingIndices(int codePoint) =>
    overrides[codePoint] ?? common.supportingIndices(codePoint, patterns);

String supportedString(
  List<int> platformIndices, {
  bool os = false,
  bool share = true,
}) =>
    common.supportedString(
      platformIndices,
      platformToVersionString,
      osName: os ? 'Android' : null,
      share: share ? supportedShare(platformIndices) : null,
    );

double supportedShare(List<int> platformIndices) =>
    common.supportedShare(platformIndices, distribution);

String versionCoverageString() =>
    common.versionCoverageString(_allPlatformIndices, platformToVersionString);
