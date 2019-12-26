import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:isittofu/data/android.dart' as android_data;
import 'package:isittofu/data/ios.dart' as ios_data;
import 'package:isittofu/util.dart';

const _kLimitedSupportThreshold = 0.7;

enum SupportLevel { fullySupported, limitedSupport, unsupported }

class Analyzer {
  const Analyzer();

  TextAnalysis analyzeText(String text) {
    final uniqueCodePoints = text.runes.unique();
    final codePointAnalyses = uniqueCodePoints
        .fold<Map<int, CodePointAnalysis>>({}, (acc, codePoint) {
      acc[codePoint] = analyzeCodePoint(codePoint);
      return acc;
    });
    return TextAnalysis(text, uniqueCodePoints, codePointAnalyses);
  }

  CodePointAnalysis analyzeCodePoint(int codePoint) {
    logDebug('Inspecting codepoint $codePoint');
    final iosIndices = ios_data.supportingIndices(codePoint);
    logDebug('iOS indices: $iosIndices');
    final androidIndices = android_data.supportingIndices(codePoint);
    logDebug('Android indices: $androidIndices');
    logDebug('Done inspecting codepoint $codePoint');
    return CodePointAnalysis(
      ios: CodePointPlatformAnalysis(codePoint, iosIndices),
      android: CodePointPlatformAnalysis(codePoint, androidIndices),
    );
  }
}

class TextAnalysis {
  TextAnalysis.empty() : this('', [], {});

  TextAnalysis(this.text, Iterable<int> uniqueCodePoints,
      Map<int, CodePointAnalysis> analysis)
      : assert(text != null),
        assert(uniqueCodePoints != null),
        assert(analysis != null),
        uniqueCodePoints = List.unmodifiable(uniqueCodePoints),
        sortedCodePoints = List.unmodifiable(List.of(uniqueCodePoints)
          ..sort((a, b) => analysis[a].compareTo(analysis[b]))),
        analysis = Map.unmodifiable(analysis);
  final String text;
  final List<int> uniqueCodePoints;
  final Map<int, CodePointAnalysis> analysis;
  final List<int> sortedCodePoints;

  bool get isEmpty => text.isEmpty;

  CodePointAnalysis analysisForIndex(int i) => analysis[uniqueCodePoints[i]];

  List<int> get iosSupportedIndices =>
      _supportedIndices(analysis.values.map((analysis) => analysis.ios));

  List<int> get androidSupportedIndices =>
      _supportedIndices(analysis.values.map((analysis) => analysis.android));

  List<int> _supportedIndices(Iterable<CodePointPlatformAnalysis> analyses) =>
      analyses.isEmpty
          ? []
          : analyses
              .map((analysis) => analysis.platformIndices.toSet())
              .reduce((acc, indices) => acc.intersection(indices))
              .toList()
        ..sort();

  String get iosSupportString {
    // Avoid calculating indices twice
    final indices = iosSupportedIndices;
    return ios_data.supportedString(indices, ios_data.supportedShare(indices));
  }

  String get androidSupportString {
    // Avoid calculating indices twice
    final indices = androidSupportedIndices;
    return android_data.supportedString(
        indices, android_data.supportedShare(indices));
  }
}

final _kRemoveChars = RegExp(r'[\n\r]');

class CodePointAnalysis implements Comparable {
  CodePointAnalysis({@required this.ios, @required this.android})
      : assert(ios != null),
        assert(android != null),
        assert(ios.codePoint == android.codePoint);

  final CodePointPlatformAnalysis ios;
  final CodePointPlatformAnalysis android;

  int get codePoint => ios.codePoint;

  String get codePointDisplayString =>
      String.fromCharCode(codePoint).replaceAll(_kRemoveChars, '');

  String get codePointHex => 'U+${codePoint.toRadixString(16).padLeft(4, '0')}';

  SupportLevel get supportLevel {
    if (fullySupported) {
      return minSupportShare < _kLimitedSupportThreshold
          ? SupportLevel.limitedSupport
          : SupportLevel.fullySupported;
    } else {
      return SupportLevel.unsupported;
    }
  }

  bool get fullySupported => ios.supported && android.supported;

  bool get partiallySupported => ios.supported || android.supported;

  String get iosSupportString =>
      ios_data.supportedString(ios.platformIndices, iosSupportedShare);

  String get androidSupportString => android_data.supportedString(
      android.platformIndices, androidSupportedShare);

  double get iosSupportedShare => ios_data.supportedShare(ios.platformIndices);

  double get androidSupportedShare =>
      android_data.supportedShare(android.platformIndices);

  double get minSupportShare => min(iosSupportedShare, androidSupportedShare);

  @override
  int compareTo(Object other) {
    if (other is CodePointAnalysis) {
      if (!partiallySupported && !other.partiallySupported) {
        return 0;
      } else if (partiallySupported && !other.partiallySupported) {
        return 1;
      } else if (!partiallySupported && other.partiallySupported) {
        return -1;
      }
      // Checking Android first here is arbitrary
      final androidComp = android.compareTo(other.android);
      if (androidComp != 0) {
        return androidComp;
      }
      return ios.compareTo(other.ios);
    }
    throw Exception('Cannot compare $this to $other');
  }
}

class CodePointPlatformAnalysis implements Comparable {
  CodePointPlatformAnalysis(this.codePoint, Iterable<int> platformIndices)
      : assert(codePoint != null),
        assert(platformIndices != null),
        assert(listEquals(
            platformIndices.toList(), List.of(platformIndices)..sort())),
        platformIndices = List.unmodifiable(platformIndices);

  final int codePoint;
  final List<int> platformIndices;

  bool get supported => platformIndices.isNotEmpty;

  @override
  int compareTo(Object other) {
    if (other is CodePointPlatformAnalysis) {
      // If only one is supported, that should be first
      if (!supported && !other.supported) {
        return 0;
      } else if (supported && !other.supported) {
        return 1;
      } else if (!supported && other.supported) {
        return -1;
      }
      // Otherwise sort the one with more stringent (higher minimum) supported
      // platform first. Multiply compareTo result by -1 to reverse the natural
      // sort.
      return platformIndices.first.compareTo(other.platformIndices.first) * -1;
    }
    throw Exception('Cannot compare $this to $other');
  }
}
