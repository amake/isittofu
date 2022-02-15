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
};

// Android Studio 4.1.3; previously at
// https://developer.android.com/about/dashboards
const List<double> distribution = [
  0.000, // 2.3.3
  0.000, // 4.0.3
  0.002, // 4.1 (100%)
  0.003, // 4.2 (99.8%)
  0.001, // 4.3 (99.5%)
  0.014, // 4.4 (99.4%)
  0.007, // 5.0 (98.0%)
  0.032, // 5.1 (97.3%)
  0.051, // 6.0 (94.1%)
  0.034, // 7.0 (89.0%)
  0.029, // 7.1 (85.6%)
  0.040, // 8.0 (82.7%)
  0.097, // 8.1 (78.7%)
  0.182, // 9 (69.0%)
  0.265, // 10 (50.8%)
  0.243, // 11 (24.3%)
  0.000, // 12 (not listed)
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
