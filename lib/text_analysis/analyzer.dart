import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:isittofu/data/android.dart' deferred as android_data;
import 'package:isittofu/data/ios.dart' deferred as ios_data;
import 'package:isittofu/util.dart';

const _kLimitedSupportThreshold = 0.7;

enum SupportLevel { fullySupported, limitedSupport, unsupported }

SupportLevel _supportLevel(bool overallSupport, double share) {
  if (overallSupport) {
    return share < _kLimitedSupportThreshold
        ? SupportLevel.limitedSupport
        : SupportLevel.fullySupported;
  } else {
    return SupportLevel.unsupported;
  }
}

class Analyzer {
  const Analyzer();

  Future<TextAnalysis> analyzeText(String text) async {
    final uniqueCodePoints = text.runes.unique();
    final codePointAnalyses = <int, CodePointAnalysis>{};
    for (final codePoint in uniqueCodePoints) {
      codePointAnalyses[codePoint] = await analyzeCodePoint(codePoint);
    }
    return TextAnalysis(text, uniqueCodePoints, codePointAnalyses);
  }

  Future<CodePointAnalysis> analyzeCodePoint(int codePoint) async {
    await Future.wait([ios_data.loadLibrary(), android_data.loadLibrary()]);
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
        codePointAnalyses = Map.unmodifiable(analysis);
  final String text;
  final List<int> uniqueCodePoints;
  final Map<int, CodePointAnalysis> codePointAnalyses;
  final List<int> sortedCodePoints;

  bool get isEmpty => text.isEmpty;

  CodePointAnalysis analysisForIndex(int i) =>
      codePointAnalyses[uniqueCodePoints[i]];

  List<int> get iosSupportedIndices => _supportedIndices(
      codePointAnalyses.values.map((analysis) => analysis.ios));

  List<int> get androidSupportedIndices => _supportedIndices(
      codePointAnalyses.values.map((analysis) => analysis.android));

  List<int> _supportedIndices(Iterable<CodePointPlatformAnalysis> analyses) =>
      analyses.isEmpty
          ? []
          : analyses
              .map((analysis) => analysis.platformIndices.toSet())
              .reduce((acc, indices) => acc.intersection(indices))
              .toList()
        ..sort();

  String get iosSupportString =>
      ios_data.supportedString(iosSupportedIndices, os: true);

  String get androidSupportString =>
      android_data.supportedString(androidSupportedIndices, os: true);

  SupportLevel get androidSupportLevel => isEmpty
      ? null
      : _supportLevel(
          codePointAnalyses.values
              .every((analysis) => analysis.android.supported),
          codePointAnalyses.values
              .map((analysis) => analysis.androidSupportedShare)
              .reduce(min));

  SupportLevel get iosSupportLevel => isEmpty
      ? null
      : _supportLevel(
          codePointAnalyses.values.every((analysis) => analysis.ios.supported),
          codePointAnalyses.values
              .map((analysis) => analysis.iosSupportedShare)
              .reduce(min));
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

  SupportLevel get supportLevel =>
      _supportLevel(fullySupported, minSupportShare);

  bool get fullySupported => ios.supported && android.supported;

  bool get partiallySupported => ios.supported || android.supported;

  String get iosSupportString => ios_data.supportedString(ios.platformIndices);

  String get androidSupportString =>
      android_data.supportedString(android.platformIndices);

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