import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:isittofu/data/android.dart' as android_data;
import 'package:isittofu/data/ios.dart' as ios_data;
import 'package:isittofu/util.dart';

const double kLimitedSupportThreshold = 0.7;

enum SupportLevel { fullySupported, limitedSupport, unsupported }

SupportLevel _supportLevel(
  bool fullSupport,
  bool partialSupport,
  double share,
) {
  if (fullSupport) {
    return share < kLimitedSupportThreshold
        ? SupportLevel.limitedSupport
        : SupportLevel.fullySupported;
  } else if (partialSupport) {
    return SupportLevel.limitedSupport;
  } else {
    return SupportLevel.unsupported;
  }
}

enum IssueType { mathA11y }

class Issue {
  Issue(this.type, Iterable<int> codePoints)
      : codePoints = List.unmodifiable(codePoints);

  final IssueType type;
  final List<int> codePoints;

  String get codePointsAsCSV =>
      codePoints.map((cp) => String.fromCharCode(cp)).join(', ');
}

class Analyzer {
  const Analyzer();

  Future<TextAnalysis> analyzeText(String text) async {
    final uniqueCodePoints = text.runes.unique();
    final codePointAnalyses = <int, CodePointAnalysis>{};
    for (final codePoint in uniqueCodePoints) {
      codePointAnalyses[codePoint] = await analyzeCodePoint(codePoint);
    }
    final issues = findIssues(text);
    return TextAnalysis(text, uniqueCodePoints, codePointAnalyses, issues);
  }

  Future<CodePointAnalysis> analyzeCodePoint(int codePoint) async {
    logDebug('Inspecting codepoint $codePoint');
    final iosIndices = ios_data.supportingIndices(codePoint);
    final latestIosIndex = ios_data.IosPlatform.values.length - 1;
    logDebug('iOS indices: $iosIndices; latest OS index: $latestIosIndex');
    final androidIndices = android_data.supportingIndices(codePoint);
    final latestAndroidIndex = android_data.AndroidPlatform.values.length - 1;
    logDebug(
        'Android indices: $androidIndices; latest OS index: $latestAndroidIndex');
    logDebug('Done inspecting codepoint $codePoint');
    return CodePointAnalysis(
      ios: CodePointPlatformAnalysis(codePoint, latestIosIndex, iosIndices),
      android: CodePointPlatformAnalysis(
          codePoint, latestAndroidIndex, androidIndices),
    );
  }

  Iterable<Issue> findIssues(String text) sync* {
    final mathAlphanumerics = text.runes.where(_isMathematicalAlphanumeric);
    if (mathAlphanumerics.isNotEmpty) {
      yield Issue(IssueType.mathA11y, mathAlphanumerics.unique());
    }
  }
}

bool _isMathematicalAlphanumeric(int codePoint) =>
    0x1d400 <= codePoint && codePoint <= 0x1d7ff;

class TextAnalysis {
  TextAnalysis.empty() : this('', [], {}, []);

  TextAnalysis(
    this.text,
    Iterable<int> uniqueCodePoints,
    Map<int, CodePointAnalysis> analysis,
    Iterable<Issue> issues,
  )   : uniqueCodePoints = List.unmodifiable(uniqueCodePoints),
        sortedCodePoints = List.unmodifiable(List<int>.of(uniqueCodePoints)
          ..sort((a, b) => analysis[a]!.compareTo(analysis[b]!))),
        codePointAnalyses = Map.unmodifiable(analysis),
        issues = List.unmodifiable(issues);
  final String text;
  final List<int> uniqueCodePoints;
  final Map<int, CodePointAnalysis> codePointAnalyses;
  final List<int> sortedCodePoints;
  final List<Issue> issues;

  bool get isEmpty => text.isEmpty;

  bool get hasIssues => issues.isNotEmpty;

  CodePointAnalysis analysisForIndex(int i) =>
      codePointAnalyses[uniqueCodePoints[i]]!;

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

  SupportLevel? get androidSupportLevel => isEmpty
      ? null
      : _supportLevel(
          codePointAnalyses.values
              .every((analysis) => analysis.android.supportedByLatest),
          codePointAnalyses.values
              .every((analysis) => analysis.android.supportedByAny),
          codePointAnalyses.values
              .map((analysis) => analysis.androidSupportedShare)
              .reduce(min));

  SupportLevel? get iosSupportLevel => isEmpty
      ? null
      : _supportLevel(
          codePointAnalyses.values
              .every((analysis) => analysis.ios.supportedByLatest),
          codePointAnalyses.values
              .every((analysis) => analysis.ios.supportedByAny),
          codePointAnalyses.values
              .map((analysis) => analysis.iosSupportedShare)
              .reduce(min));
}

final _kRemoveChars = RegExp(r'[\n\r]');

class CodePointAnalysis implements Comparable<CodePointAnalysis> {
  CodePointAnalysis({required this.ios, required this.android})
      : assert(ios.codePoint == android.codePoint);

  final CodePointPlatformAnalysis ios;
  final CodePointPlatformAnalysis android;

  int get codePoint => ios.codePoint;

  String get codePointDisplayString =>
      String.fromCharCode(codePoint).replaceAll(_kRemoveChars, '');

  String get codePointHex => 'U+${codePoint.toRadixString(16).padLeft(4, '0')}';

  SupportLevel get supportLevel =>
      _supportLevel(fullySupported, partiallySupported, minSupportShare);

  bool get fullySupported => ios.supportedByLatest && android.supportedByLatest;

  bool get partiallySupported => ios.supportedByAny && android.supportedByAny;

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
      final thisSupport = supportLevel;
      final otherSupport = other.supportLevel;
      if (thisSupport != otherSupport) {
        final thisSupportIdx = SupportLevel.values.indexOf(thisSupport);
        final otherSupportIdx = SupportLevel.values.indexOf(otherSupport);
        return -thisSupportIdx.compareTo(otherSupportIdx);
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

class CodePointPlatformAnalysis
    implements Comparable<CodePointPlatformAnalysis> {
  CodePointPlatformAnalysis(
    this.codePoint,
    this.latestOSIndex,
    Iterable<int> platformIndices,
  )   : assert(listEquals(
            platformIndices.toList(), List.of(platformIndices)..sort())),
        platformIndices = List.unmodifiable(platformIndices);

  final int codePoint;
  final List<int> platformIndices;
  final int latestOSIndex;

  bool get supportedByAny => platformIndices.isNotEmpty;

  bool get supportedByLatest => platformIndices.contains(latestOSIndex);

  @override
  int compareTo(Object other) {
    if (other is CodePointPlatformAnalysis) {
      // If only one is supported, that should be first
      if (!supportedByAny && !other.supportedByAny) {
        return 0;
      } else if (supportedByAny && !other.supportedByAny) {
        return 1;
      } else if (!supportedByAny && other.supportedByAny) {
        return -1;
      }

      // The one supported by the latest OS should be next
      if (supportedByLatest && !other.supportedByLatest) {
        return 1;
      } else if (!supportedByLatest && supportedByLatest) {
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
