import 'package:isittofu/data/common.dart' as common;
import 'package:isittofu/data/ios10.0.g.dart';
import 'package:isittofu/data/ios10.2.g.dart';
import 'package:isittofu/data/ios11.0.g.dart';
import 'package:isittofu/data/ios11.1.g.dart';
import 'package:isittofu/data/ios11.3.g.dart';
import 'package:isittofu/data/ios12.0.g.dart';
import 'package:isittofu/data/ios12.1.g.dart';
import 'package:isittofu/data/ios12.4.g.dart';
import 'package:isittofu/data/ios13.0.g.dart';
import 'package:isittofu/data/ios13.1.g.dart';
import 'package:isittofu/data/ios14.0.g.dart';
import 'package:isittofu/data/ios14.1.g.dart';
import 'package:isittofu/data/ios14.2.g.dart';
import 'package:isittofu/data/ios15.0.g.dart';
import 'package:isittofu/data/ios15.4.g.dart';
import 'package:isittofu/data/ios16.0.g.dart';
import 'package:isittofu/data/ios16.2.g.dart';
import 'package:isittofu/data/ios16.4.g.dart';
import 'package:isittofu/data/ios17.0.g.dart';
import 'package:isittofu/data/ios18.0.g.dart';
import 'package:isittofu/data/ios18.1.g.dart';
import 'package:isittofu/data/ios8.0.g.dart';
import 'package:isittofu/data/ios8.2.g.dart';
import 'package:isittofu/data/ios8.3.g.dart';
import 'package:isittofu/data/ios9.0.g.dart';
import 'package:isittofu/data/ios9.1.g.dart';

final List<RegExp> patterns = List.unmodifiable(<RegExp>[
  ios8_0Pattern,
  ios8_0Pattern, // iOS 8.1 is same as iOS 8.0
  ios8_2Pattern,
  ios8_3Pattern,
  ios8_3Pattern, // iOS 8.4 is same as iOS 8.3
  ios9_0Pattern,
  ios9_1Pattern,
  ios9_1Pattern, // iOS 9.2 is same as iOS 9.1
  ios9_1Pattern, // iOS 9.3 is same as iOS 9.1
  ios10_0Pattern,
  ios10_0Pattern, // iOS 10.1 is same as iOS 10.0
  ios10_2Pattern,
  ios10_2Pattern, // iOS 10.3 is same as iOS 10.2
  ios11_0Pattern,
  ios11_1Pattern,
  ios11_1Pattern, // iOS 11.2 is same as iOS 11.1
  ios11_3Pattern,
  ios11_3Pattern, // iOS 11.4 is same as iOS 11.3
  ios12_0Pattern,
  ios12_1Pattern,
  ios12_1Pattern, // iOS 12.2 is same as iOS 12.1
  ios12_1Pattern, // iOS 12.3 is same as iOS 12.1
  ios12_4Pattern,
  ios13_0Pattern,
  ios13_1Pattern,
  ios13_1Pattern, // iOS 13.2 is same as iOS 13.1
  ios13_1Pattern, // iOS 13.3 is same as iOS 13.1
  ios13_1Pattern, // iOS 13.4 is same as iOS 13.1
  ios13_1Pattern, // iOS 13.5 is same as iOS 13.1
  ios13_1Pattern, // iOS 13.6 is same as iOS 13.1
  ios13_1Pattern, // iOS 13.7 is same as iOS 13.1
  ios14_0Pattern,
  ios14_1Pattern, // iOS 14.1 differs by a single PUA codepoint; remove this?
  ios14_2Pattern,
  ios14_2Pattern, // iOS 14.3 is same as iOS 14.2
  ios14_2Pattern, // iOS 14.4 is same as iOS 14.2
  ios14_2Pattern, // iOS 14.5 is same as iOS 14.2
  ios14_2Pattern, // iOS 14.6 is same as iOS 14.2
  ios14_2Pattern, // iOS 14.7 is same as iOS 14.2
  ios14_2Pattern, // iOS 14.8 is same as iOS 14.2
  ios15_0Pattern,
  ios15_0Pattern, // iOS 15.1 is same as iOS 15.0
  ios15_0Pattern, // iOS 15.2 is same as iOS 15.0
  ios15_0Pattern, // iOS 15.3 is same as iOS 15.0
  ios15_4Pattern,
  ios15_4Pattern, // iOS 15.5 is same as iOS 15.4
  ios15_4Pattern, // iOS 15.6 is same as iOS 15.4
  ios15_4Pattern, // iOS 15.7 is same as iOS 15.4
  ios16_0Pattern,
  ios16_0Pattern, // iOS 16.1 is same as iOS 16.0
  ios16_2Pattern,
  ios16_2Pattern, // iOS 16.3 is same as iOS 16.2
  ios16_4Pattern,
  ios16_4Pattern, // iOS 16.5 is same as iOS 16.4
  ios16_4Pattern, // iOS 16.6 is same as iOS 16.4
  ios17_0Pattern,
  ios17_0Pattern, // iOS 17.1 is same as iOS 17.0
  ios17_0Pattern, // iOS 17.2 is same as iOS 17.0
  ios17_0Pattern, // iOS 17.3 is same as iOS 17.0
  ios17_0Pattern, // iOS 17.4 is same as iOS 17.0
  ios17_0Pattern, // iOS 17.5 is same as iOS 17.0
  ios17_0Pattern, // iOS 17.6 is same as iOS 17.0
  ios17_0Pattern, // iOS 17.7 is same as iOS 17.0
  ios18_0Pattern,
  ios18_1Pattern,
  ios18_1Pattern, // iOS 18.2 is same as iOS 18.1
  ios18_1Pattern, // iOS 18.3 is same as iOS 18.1
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
  iOS12_3,
  iOS12_4,
  iOS13_0,
  iOS13_1,
  iOS13_2,
  iOS13_3,
  iOS13_4,
  iOS13_5,
  iOS13_6,
  iOS13_7,
  iOS14_0,
  iOS14_1,
  iOS14_2,
  iOS14_3,
  iOS14_4,
  iOS14_5,
  iOS14_6,
  iOS14_7,
  iOS14_8,
  iOS15_0,
  iOS15_1,
  iOS15_2,
  iOS15_3,
  iOS15_4,
  iOS15_5,
  iOS15_6,
  iOS15_7,
  iOS16_0,
  iOS16_1,
  iOS16_2,
  iOS16_3,
  iOS16_4,
  iOS16_5,
  iOS16_6,
  iOS17_0,
  iOS17_1,
  iOS17_2,
  iOS17_3,
  iOS17_4,
  iOS17_5,
  iOS17_6,
  iOS17_7,
  iOS18_0,
  iOS18_1,
  iOS18_2,
  iOS18_3,
}

// As measured by the App Store on June 9, 2024
// https://developer.apple.com/support/app-store/
const List<double> distribution = [
  0.09 / 48, // iOS8_0
  0.09 / 48, // iOS8_1
  0.09 / 48, // iOS8_2
  0.09 / 48, // iOS8_3
  0.09 / 48, // iOS8_4
  0.09 / 48, // iOS9_0
  0.09 / 48, // iOS9_1
  0.09 / 48, // iOS9_2
  0.09 / 48, // iOS9_3
  0.09 / 48, // iOS10_0
  0.09 / 48, // iOS10_1
  0.09 / 48, // iOS10_2
  0.09 / 48, // iOS10_3
  0.09 / 48, // iOS11_0
  0.09 / 48, // iOS11_1
  0.09 / 48, // iOS11_2
  0.09 / 48, // iOS11_3
  0.09 / 48, // iOS11_4
  0.09 / 48, // iOS12_0
  0.09 / 48, // iOS12_1
  0.09 / 48, // iOS12_2
  0.09 / 48, // iOS12_3
  0.09 / 48, // iOS12_4
  0.09 / 48, // iOS13_0
  0.09 / 48, // iOS13_1
  0.09 / 48, // iOS13_2
  0.09 / 48, // iOS13_3
  0.09 / 48, // iOS13_4
  0.09 / 48, // iOS13_5
  0.09 / 48, // iOS13_6
  0.09 / 48, // iOS13_7
  0.09 / 48, // iOS14_0
  0.09 / 48, // iOS14_1
  0.09 / 48, // iOS14_2
  0.09 / 48, // iOS14_3
  0.09 / 48, // iOS14_4
  0.09 / 48, // iOS14_5
  0.09 / 48, // iOS14_6
  0.09 / 48, // iOS14_7
  0.09 / 48, // iOS14_8
  0.09 / 48, // iOS15_0
  0.09 / 48, // iOS15_1
  0.09 / 48, // iOS15_2
  0.09 / 48, // iOS15_3
  0.09 / 48, // iOS15_4
  0.09 / 48, // iOS15_5
  0.09 / 48, // iOS15_6
  0.09 / 48, // iOS15_7
  0.14 / 7, // iOS16_0
  0.14 / 7, // iOS16_1
  0.14 / 7, // iOS16_2
  0.14 / 7, // iOS16_3
  0.14 / 7, // iOS16_4
  0.14 / 7, // iOS16_5
  0.14 / 7, // iOS16_6
  0.77 / 6, // iOS17_0
  0.77 / 6, // iOS17_1
  0.77 / 6, // iOS17_2
  0.77 / 6, // iOS17_3
  0.77 / 6, // iOS17_4
  0.77 / 6, // iOS17_5
  0, // iOS17_6
  0, // iOS17_7
  0, // iOS18_0
  0, // iOS18_1
  0, // iOS18_2
  0, // iOS18_3
];

final _allPlatformIndices = List.generate(IosPlatform.values.length, (i) => i);

final Map<int, List<int>> overrides = Map.unmodifiable(<int, List<int>>{
  // VARIATION SELECTORs do not have glyphs in all versions but are supported
  for (var i = 0xfe00; i <= 0xfe0f; i++) i: _allPlatformIndices,
});

String _toVersionString(int platformIdx) => IosPlatform.values[platformIdx]
    .toString()
    .split('.')[1]
    .replaceFirst('iOS', '')
    .replaceFirst('_', '.');

Iterable<int> supportingIndices(int codePoint) =>
    overrides[codePoint] ?? common.supportingIndices(codePoint, patterns);

String supportedString(
  List<int> platformIndices, {
  bool os = false,
  bool share = true,
}) =>
    common.supportedString(
      platformIndices,
      _toVersionString,
      osName: os ? 'iOS' : null,
      share: share ? supportedShare(platformIndices) : null,
    );

double supportedShare(List<int> platformIndices) =>
    common.supportedShare(platformIndices, distribution);

String versionCoverageString() =>
    common.versionCoverageString(_allPlatformIndices, _toVersionString);
