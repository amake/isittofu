import 'package:bloom_filter/bloom_filter.dart';
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
import 'package:isittofu/data/common.dart' as common;

final List<BloomFilter> bloomFilters = [
  android10BloomFilter,
  android15BloomFilter,
  android16BloomFilter,
  android17BloomFilter,
  android18BloomFilter,
  android19BloomFilter,
  android21BloomFilter,
  android21BloomFilter, // Android 22 is same as Android 21
  android23BloomFilter,
  android24BloomFilter,
  android24BloomFilter, // Android 25 is same as Android 24
  android26BloomFilter,
  android26BloomFilter, // Android 27 is same as Android 26
  android28BloomFilter,
  android29BloomFilter,
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
