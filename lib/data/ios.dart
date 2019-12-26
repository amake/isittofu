import 'package:bloom_filter/bloom_filter.dart';
import 'package:isittofu/data/common.dart' as common;
import 'package:isittofu/data/ios10.0-glyphs-decimal.g.dart';
import 'package:isittofu/data/ios10.2-glyphs-decimal.g.dart';
import 'package:isittofu/data/ios11.0-glyphs-decimal.g.dart';
import 'package:isittofu/data/ios11.1-glyphs-decimal.g.dart';
import 'package:isittofu/data/ios11.3-glyphs-decimal.g.dart';
import 'package:isittofu/data/ios12.0-glyphs-decimal.g.dart';
import 'package:isittofu/data/ios12.1-glyphs-decimal.g.dart';
import 'package:isittofu/data/ios12.4-glyphs-decimal.g.dart';
import 'package:isittofu/data/ios13.0-glyphs-decimal.g.dart';
import 'package:isittofu/data/ios13.2-glyphs-decimal.g.dart';
import 'package:isittofu/data/ios8.0-glyphs-decimal.g.dart';
import 'package:isittofu/data/ios8.2-glyphs-decimal.g.dart';
import 'package:isittofu/data/ios8.3-glyphs-decimal.g.dart';
import 'package:isittofu/data/ios9.0-glyphs-decimal.g.dart';
import 'package:isittofu/data/ios9.1-glyphs-decimal.g.dart';

final List<BloomFilter> bloomFilters = List.unmodifiable([
  ios8_0GlyphsDecimalBloomFilter,
  ios8_0GlyphsDecimalBloomFilter, // iOS 8.1 is same as iOS 8.0
  ios8_2GlyphsDecimalBloomFilter,
  ios8_3GlyphsDecimalBloomFilter,
  ios8_3GlyphsDecimalBloomFilter, // iOS 8.4 is same as iOS 8.3
  ios9_0GlyphsDecimalBloomFilter,
  ios9_1GlyphsDecimalBloomFilter,
  ios9_1GlyphsDecimalBloomFilter, // iOS 9.2 is same as iOS 9.1
  ios9_1GlyphsDecimalBloomFilter, // iOS 9.3 is same as iOS 9.1
  ios10_0GlyphsDecimalBloomFilter,
  ios10_0GlyphsDecimalBloomFilter, // iOS 10.1 is same as iOS 10.0
  ios10_2GlyphsDecimalBloomFilter,
  ios10_2GlyphsDecimalBloomFilter, // iOS 10.3 is same as iOS 10.2
  ios11_0GlyphsDecimalBloomFilter,
  ios11_1GlyphsDecimalBloomFilter,
  ios11_1GlyphsDecimalBloomFilter, // iOS 11.2 is same as iOS 11.1
  ios11_3GlyphsDecimalBloomFilter,
  ios11_3GlyphsDecimalBloomFilter, // iOS 11.4 is same as iOS 11.3
  ios12_0GlyphsDecimalBloomFilter,
  ios12_1GlyphsDecimalBloomFilter,
  ios12_1GlyphsDecimalBloomFilter, // iOS 12.2 is same as iOS 12.1
  ios12_4GlyphsDecimalBloomFilter,
  ios13_0GlyphsDecimalBloomFilter,
  ios13_0GlyphsDecimalBloomFilter, // iOS 13.1 is same as iOS 13.0
  ios13_2GlyphsDecimalBloomFilter,
  ios13_2GlyphsDecimalBloomFilter, // iOS 13.3 is same as iOS 13.2
]);

enum IosPlatform {
  iOS8_0,
  iOS8_1,
  iOS8_2,
  iOS8_3,
  iOS8_4,
  iOS9_0,
  iOS9_1,
  iOS9_2,
  iOS9_3,
  iOS10_0,
  iOS10_1,
  iOS10_2,
  iOS10_3,
  iOS11_0,
  iOS11_1,
  iOS11_2,
  iOS11_3,
  iOS11_4,
  iOS12_0,
  iOS12_1,
  iOS12_2,
  iOS12_4,
  iOS13_0,
  iOS13_1,
  iOS13_2,
  iOS13_3,
}

// https://developer.apple.com/support/app-store/
const List<double> distribution = [
  0.09 / 18,
  0.09 / 18,
  0.09 / 18,
  0.09 / 18,
  0.09 / 18,
  0.09 / 18,
  0.09 / 18,
  0.09 / 18,
  0.09 / 18,
  0.09 / 18,
  0.09 / 18,
  0.09 / 18,
  0.09 / 18,
  0.09 / 18,
  0.09 / 18,
  0.09 / 18,
  0.09 / 18,
  0.09 / 18,
  0.41 / 4,
  0.41 / 4,
  0.41 / 4,
  0.41 / 4,
  0.5 / 4,
  0.5 / 4,
  0.5 / 4,
  0.5 / 4,
];

String _toVersionString(int platformIdx) => IosPlatform.values[platformIdx]
    .toString()
    .split('.')[1]
    .replaceFirst('iOS', '')
    .replaceFirst('_', '.');

Iterable<int> supportingIndices(int codePoint) =>
    common.supportingIndices(codePoint, bloomFilters);

String supportedString(List<int> platformIndices, double share) =>
    common.supportedString(platformIndices, _toVersionString, 'iOS', share);

double supportedShare(List<int> platformIndices) =>
    platformIndices.map((i) => distribution[i]).reduce((a, b) => a + b);
