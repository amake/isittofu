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
  final rangeStrings = platformIndices.ranges().map((range) {
    assert(range.length == 2, 'Range list must have two members; was $range');
    if (range[0] == range[1]) {
      return versionConverter(range[0]);
    } else {
      final start = versionConverter(range[0]);
      final end = versionConverter(range[1]);
      return '$start–$end';
    }
  });
  final range = rangeStrings.join(', ');
  final withoutShare = osName == null ? range : '$osName $range';

  if (share == null) {
    return withoutShare;
  } else {
    final sharePct = (share * 100).round();
    return '$withoutShare ($sharePct%)';
  }
}

double supportedShare(List<int> platformIndices, List<double> distribution) =>
    platformIndices.isEmpty
        ? 0
        : platformIndices.map((i) => distribution[i]).reduce((a, b) => a + b);
