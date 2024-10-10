import 'package:isittofu/util.dart';

Iterable<int> supportingIndices(int codePoint, List<RegExp> patterns) sync* {
  for (var i = 0; i < patterns.length; i++) {
    final b = patterns[i];
    if (b.hasMatch(String.fromCharCode(codePoint))) {
      yield i;
    }
  }
}

typedef VersionConverter = String Function(int);

String supportedString(
  List<int> platformIndices,
  VersionConverter versionConverter, {
  String? osName,
  double? share,
}) {
  if (platformIndices.isEmpty) {
    return osName == null ? 'Unsupported' : '$osName unsupported';
  }
  final range = platformIndices
      .ranges()
      .map((range) => versionRangeString(range, versionConverter))
      .join(', ');
  final withoutShare = osName == null ? range : '$osName $range';

  if (share == null) {
    return withoutShare;
  } else {
    final sharePct = (share * 100).round();
    return '$withoutShare ($sharePct%)';
  }
}

String versionRangeString(Range range, VersionConverter versionConverter) {
  if (range.from == range.to) {
    return versionConverter(range.from);
  } else {
    final start = versionConverter(range.from);
    final end = versionConverter(range.to);
    return '$start–$end';
  }
}

double supportedShare(List<int> platformIndices, List<double> distribution) =>
    platformIndices.isEmpty
        ? 0
        : platformIndices.map((i) => distribution[i]).reduce((a, b) => a + b);

String versionCoverageString(
    List<int> platformIndices, VersionConverter versionConverter) {
  final range = versionRangeString(
      (from: platformIndices.first, to: platformIndices.last),
      versionConverter);
  return 'Evaluated versions $range';
}
