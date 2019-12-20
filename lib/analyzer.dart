import 'package:isittofu/data/android.dart' as androidData;
import 'package:isittofu/data/ios.dart' as iosData;
import 'package:isittofu/util.dart';

class Analyzer {
  const Analyzer();

  TextAnalysis analyzeText(String text) {
    final uniqueCodePoints = text.runes.unique();
    final codePointAnalyses =
        uniqueCodePoints.fold(<int, CodePointAnalysis>{}, (acc, codePoint) {
      acc[codePoint] = analyzeCodePoint(codePoint);
      return acc;
    });
    return TextAnalysis(text, uniqueCodePoints, codePointAnalyses);
  }

  CodePointAnalysis analyzeCodePoint(int codePoint) {
    print('Inspecting codepoint $codePoint');
    final iosIndices = iosData.supportingIndices(codePoint);
    print('iOS indices: $iosIndices');
    final iosRanges = iosIndices.ranges();
    print('iOS ranges: $iosRanges');
    final iosMessage = iosData.supportedString(iosRanges);
    print('iOS message: $iosMessage');
    final androidIndices = androidData.supportingIndices(codePoint);
    print('Android indices: $androidIndices');
    final androidRanges = androidIndices.ranges();
    print('Android ranges: $androidRanges');
    final androidMessage = androidData.supportedString(androidRanges);
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

  CodePointAnalysis analysisForIndex(int i) => analysis[uniqueCodePoints[i]];
}

class CodePointAnalysis {
  CodePointAnalysis({this.ios, this.android})
      : assert(ios != null),
        assert(android != null),
        assert(ios.codePoint == android.codePoint);

  final CodePointPlatformAnalysis ios;
  final CodePointPlatformAnalysis android;

  int get codePoint => ios.codePoint;

  String get codePointHex => 'U+${codePoint.toRadixString(16)}';

  bool get supported => ios.supported && android.supported;

  String get iosSupportString => iosData.supportedString(ios.ranges);

  String get androidSupportString =>
      androidData.supportedString(android.ranges);
}

class CodePointPlatformAnalysis {
  CodePointPlatformAnalysis(
      this.codePoint, Iterable<int> platformIndices, Iterable<List<int>> ranges)
      : assert(codePoint != null),
        assert(platformIndices != null),
        assert(ranges != null),
        platformIndices = List.unmodifiable(platformIndices),
        ranges = List.unmodifiable(ranges);

  final int codePoint;
  final List<int> platformIndices;
  final List<List<int>> ranges;

  bool get supported => platformIndices.isNotEmpty;
}
