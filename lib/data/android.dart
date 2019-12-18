import 'package:isittofu/data/android10.g.dart';
import 'package:isittofu/data/android11.g.dart';
import 'package:isittofu/data/android12.g.dart';
import 'package:isittofu/data/android13.g.dart';
import 'package:isittofu/data/android14.g.dart';
import 'package:isittofu/data/android15.g.dart';
import 'package:isittofu/data/android16.g.dart';
import 'package:isittofu/data/android17.g.dart';
import 'package:isittofu/data/android18.g.dart';
import 'package:isittofu/data/android19.g.dart';
import 'package:isittofu/data/android2.g.dart';
import 'package:isittofu/data/android20.g.dart';
import 'package:isittofu/data/android21.g.dart';
import 'package:isittofu/data/android22.g.dart';
import 'package:isittofu/data/android23.g.dart';
import 'package:isittofu/data/android24.g.dart';
import 'package:isittofu/data/android25.g.dart';
import 'package:isittofu/data/android26.g.dart';
import 'package:isittofu/data/android27.g.dart';
import 'package:isittofu/data/android28.g.dart';
import 'package:isittofu/data/android29.g.dart';
import 'package:isittofu/data/android3.g.dart';
import 'package:isittofu/data/android4.g.dart';
import 'package:isittofu/data/android5.g.dart';
import 'package:isittofu/data/android6.g.dart';
import 'package:isittofu/data/android7.g.dart';
import 'package:isittofu/data/android8.g.dart';
import 'package:isittofu/data/android9.g.dart';
import 'package:isittofu/data/common.dart' as common;

final bloomFilters = [
  android2BloomFilter,
  android3BloomFilter,
  android4BloomFilter,
  android5BloomFilter,
  android6BloomFilter,
  android7BloomFilter,
  android8BloomFilter,
  android9BloomFilter,
  android10BloomFilter,
  android11BloomFilter,
  android12BloomFilter,
  android13BloomFilter,
  android14BloomFilter,
  android15BloomFilter,
  android16BloomFilter,
  android17BloomFilter,
  android18BloomFilter,
  android19BloomFilter,
  android20BloomFilter,
  android21BloomFilter,
  android22BloomFilter,
  android23BloomFilter,
  android24BloomFilter,
  android25BloomFilter,
  android26BloomFilter,
  android27BloomFilter,
  android28BloomFilter,
  android29BloomFilter,
];

enum AndroidPlatform {
  Android2,
  Android3,
  Android4,
  Android5,
  Android6,
  Android7,
  Android8,
  Android9,
  Android10,
  Android11,
  Android12,
  Android13,
  Android14,
  Android15,
  Android16,
  Android17,
  Android18,
  Android19,
  Android20,
  Android21,
  Android22,
  Android23,
  Android24,
  Android25,
  Android26,
  Android27,
  Android28,
  Android29,
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

String _toVersionString(int platformIdx) {
  final sdk = AndroidPlatform.values[platformIdx]
      .toString()
      .split('.')[1]
      .replaceFirst('Android', '');
  return sdkToVersion[sdk];
}

Iterable<int> supportingIndices(int codePoint) =>
    common.supportingIndices(codePoint, bloomFilters);

String supportedString(List<List<int>> ranges) =>
    common.supportedString(ranges, _toVersionString, 'Android');
