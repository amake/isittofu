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

final List<BloomFilter> bloomFilters = [
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
];

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
const sdkToVersion = {
  '2': '1.1',
  '3': '1.5',
  '4': '1.6',
  '5': '2.0',
  '6': '2.0.1',
  '7': '2.1',
  '8': '2.2',
  '9': '2.3',
  '10': '2.3.3',
  '11': '3.0',
  '12': '3.1',
  '13': '3.2',
  '14': '4.0.1',
  '15': '4.0.3',
  '16': '4.1',
  '17': '4.2',
  '18': '4.3',
  '19': '4.4',
  '20': '?',
  '21': '5.0',
  '22': '5.1',
  '23': '6.0',
  '24': '7.0',
  '25': '7.1',
  '26': '8.0',
  '27': '8.1',
  '28': '9',
  '29': '10',
};

String platformToVersionString(int platformIdx) {
  final sdk = AndroidPlatform.values[platformIdx]
      .toString()
      .split('.')[1]
      .replaceFirst('android', '');
  return sdkToVersion[sdk];
}

Iterable<int> supportingIndices(int codePoint) =>
    common.supportingIndices(codePoint, bloomFilters);

String supportedString(List<List<int>> ranges) =>
    common.supportedString(ranges, platformToVersionString, 'Android');
