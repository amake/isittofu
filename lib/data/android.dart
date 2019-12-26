import 'package:bloom_filter/bloom_filter.dart';
import 'package:isittofu/data/android10-glyphs-decimal.g.dart';
import 'package:isittofu/data/android15-glyphs-decimal.g.dart';
import 'package:isittofu/data/android16-glyphs-decimal.g.dart';
import 'package:isittofu/data/android17-glyphs-decimal.g.dart';
import 'package:isittofu/data/android18-glyphs-decimal.g.dart';
import 'package:isittofu/data/android19-glyphs-decimal.g.dart';
import 'package:isittofu/data/android21-glyphs-decimal.g.dart';
import 'package:isittofu/data/android23-glyphs-decimal.g.dart';
import 'package:isittofu/data/android24-glyphs-decimal.g.dart';
import 'package:isittofu/data/android26-glyphs-decimal.g.dart';
import 'package:isittofu/data/android28-glyphs-decimal.g.dart';
import 'package:isittofu/data/android29-glyphs-decimal.g.dart';
import 'package:isittofu/data/common.dart' as common;

final List<BloomFilter> bloomFilters = List.unmodifiable([
  android10GlyphsDecimalBloomFilter,
  android15GlyphsDecimalBloomFilter,
  android16GlyphsDecimalBloomFilter,
  android17GlyphsDecimalBloomFilter,
  android18GlyphsDecimalBloomFilter,
  android19GlyphsDecimalBloomFilter,
  android21GlyphsDecimalBloomFilter,
  android21GlyphsDecimalBloomFilter, // Android 22 is same as Android 21
  android23GlyphsDecimalBloomFilter,
  android24GlyphsDecimalBloomFilter,
  android24GlyphsDecimalBloomFilter, // Android 25 is same as Android 24
  android26GlyphsDecimalBloomFilter,
  android26GlyphsDecimalBloomFilter, // Android 27 is same as Android 26
  android28GlyphsDecimalBloomFilter,
  android29GlyphsDecimalBloomFilter,
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
};

// https://developer.android.com/about/dashboards
const List<double> distribution = [
  0.003,
  0.003,
  0.012,
  0.015,
  0.005,
  0.069,
  0.03,
  0.115,
  0.169,
  0.114,
  0.078,
  0.129,
  0.154,
  0.104,
  0,
];

String platformToVersionString(int platformIdx) =>
    sdkToVersion[AndroidPlatform.values[platformIdx]];

Iterable<int> supportingIndices(int codePoint) =>
    common.supportingIndices(codePoint, bloomFilters);

String supportedString(List<int> platformIndices, double share) =>
    common.supportedString(
        platformIndices, platformToVersionString, 'Android', share);

double supportedShare(List<int> platformIndices) =>
    common.supportedShare(platformIndices, distribution);
