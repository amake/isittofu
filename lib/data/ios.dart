import 'package:isittofu/data/common.dart' as common;
import 'package:isittofu/data/ios10.0.g.dart';
import 'package:isittofu/data/ios10.2.g.dart';
import 'package:isittofu/data/ios10.3.g.dart';
import 'package:isittofu/data/ios11.0.g.dart';
import 'package:isittofu/data/ios11.1.g.dart';
import 'package:isittofu/data/ios11.4.g.dart';
import 'package:isittofu/data/ios12.0.g.dart';
import 'package:isittofu/data/ios12.1.g.dart';
import 'package:isittofu/data/ios12.2.g.dart';
import 'package:isittofu/data/ios12.3.g.dart';
import 'package:isittofu/data/ios13.0.g.dart';
import 'package:isittofu/data/ios13.2.g.dart';
import 'package:isittofu/data/ios8.1.g.dart';
import 'package:isittofu/data/ios8.2.g.dart';
import 'package:isittofu/data/ios8.3.g.dart';
import 'package:isittofu/data/ios9.0.g.dart';
import 'package:isittofu/data/ios9.1.g.dart';

final bloomFilters = [
  ios8_1BloomFilter,
  ios8_2BloomFilter,
  ios8_3BloomFilter,
  ios8_3BloomFilter, // iOS 8.4 is same as iOS 8.3
  ios9_0BloomFilter,
  ios9_1BloomFilter,
  ios9_1BloomFilter, // iOS 9.2 is same as iOS 9.1
  ios9_1BloomFilter, // iOS 9.3 is same as iOS 9.1
  ios10_0BloomFilter,
  ios10_0BloomFilter, // iOS 10.1 is same as iOS 10.0
  ios10_2BloomFilter,
  ios10_3BloomFilter,
  ios11_0BloomFilter,
  ios11_1BloomFilter,
  ios11_1BloomFilter, // iOS 11.2 is same as iOS 11.1
  ios11_1BloomFilter, // iOS 11.3 is same as iOS 11.1
  ios11_4BloomFilter,
  ios12_0BloomFilter,
  ios12_1BloomFilter,
  ios12_2BloomFilter,
  ios12_3BloomFilter,
  ios12_3BloomFilter, // iOS 12.4 is same as iOS 12.3
  ios13_0BloomFilter,
  ios13_0BloomFilter, // iOS 13.1 is same as iOS 13.0
  ios13_2BloomFilter,
  ios13_2BloomFilter, // iOS 13.3 is same as iOS 13.2
];

enum IOSPlatform {
  IOS8_1,
  IOS8_2,
  IOS8_3,
  IOS8_4,
  IOS9_0,
  IOS9_1,
  IOS9_2,
  IOS9_3,
  IOS10_0,
  IOS10_1,
  IOS10_2,
  IOS10_3,
  IOS11_0,
  IOS11_1,
  IOS11_2,
  IOS11_3,
  IOS11_4,
  IOS12_0,
  IOS12_1,
  IOS12_2,
  IOS12_3,
  IOS12_4,
  IOS13_0,
  IOS13_1,
  IOS13_2,
  IOS13_3,
}

String _toVersionString(int platformIdx) => IOSPlatform.values[platformIdx]
    .toString()
    .split('.')[1]
    .replaceFirst('IOS', '')
    .replaceFirst('_', '.');

Iterable<int> supportingIndices(int codePoint) =>
    common.supportingIndices(codePoint, bloomFilters);

String supportedString(List<List<int>> ranges) =>
    common.supportedString(ranges, _toVersionString, 'iOS');
