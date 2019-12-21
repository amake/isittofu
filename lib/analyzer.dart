import 'package:flutter/foundation.dart';
import 'package:isittofu/data/android.dart' as android_data;
import 'package:isittofu/data/ios.dart' as ios_data;
import 'package:isittofu/util.dart';

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
    print('Inspecting codepoint $codePoint');
    final iosIndices = ios_data.supportingIndices(codePoint);
    print('iOS indices: $iosIndices');
    final iosRanges = iosIndices.ranges();
    print('iOS ranges: $iosRanges');
    final iosMessage = ios_data.supportedString(iosRanges);
    print('iOS message: $iosMessage');
    final androidIndices = android_data.supportingIndices(codePoint);
    print('Android indices: $androidIndices');
    final androidRanges = androidIndices.ranges();
    print('Android ranges: $androidRanges');
    final androidMessage = android_data.supportedString(androidRanges);
    print('Android message: $androidMessage');
    print('Done inspecting codepoint $codePoint');
    return CodePointAnalysis(
      ios: CodePointPlatformAnalysis(codePoint, iosIndices, iosRanges),
      android:
          CodePointPlatformAnalysis(codePoint, androidIndices, androidRanges),
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
        analysis = Map.unmodifiable(analysis);
  final String text;
  final List<int> uniqueCodePoints;
  final Map<int, CodePointAnalysis> analysis;

  bool get isEmpty => text.isEmpty;

  CodePointAnalysis analysisForIndex(int i) => analysis[uniqueCodePoints[i]];

  List<int> get iosSupportedIndices =>
      supportedIndices(analysis.values.map((analysis) => analysis.ios));

  List<int> get androidSupportedIndices =>
      supportedIndices(analysis.values.map((analysis) => analysis.android));

  List<int> supportedIndices(Iterable<CodePointPlatformAnalysis> analyses) =>
      analyses.isEmpty
          ? []
          : analyses
              .map((analysis) => analysis.platformIndices.toSet())
              .reduce((acc, indices) => acc.intersection(indices))
              .toList()
        ..sort();

  String get iosSupportString =>
      ios_data.supportedString(iosSupportedIndices.ranges());

  String get androidSupportString =>
      android_data.supportedString(androidSupportedIndices.ranges());
}

class CodePointAnalysis {
  CodePointAnalysis({@required this.ios, @required this.android})
      : assert(ios != null),
        assert(android != null),
        assert(ios.codePoint == android.codePoint);

  final CodePointPlatformAnalysis ios;
  final CodePointPlatformAnalysis android;

  int get codePoint => ios.codePoint;

  String get codePointHex => 'U+${codePoint.toRadixString(16).padLeft(4, '0')}';

  bool get supported => ios.supported && android.supported;

  String get iosSupportString => ios_data.supportedString(ios.ranges);

  String get androidSupportString =>
      android_data.supportedString(android.ranges);
}

class CodePointPlatformAnalysis {
  CodePointPlatformAnalysis(
      this.codePoint, Iterable<int> platformIndices, Iterable<List<int>> ranges)
      : assert(codePoint != null),
        assert(platformIndices != null),
        assert(listEquals(
            platformIndices.toList(), List.of(platformIndices)..sort())),
        assert(ranges != null),
        platformIndices = List.unmodifiable(platformIndices),
        ranges = List.unmodifiable(ranges);

  final int codePoint;
  final List<int> platformIndices;
  final List<List<int>> ranges;

  bool get supported => platformIndices.isNotEmpty;
}
