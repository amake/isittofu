import 'package:bloom_filter/bloom_filter.dart';
import 'package:isittofu/util.dart';

Iterable<int> supportingIndices(
    int codePoint, List<BloomFilter> bloomFilters) sync* {
  for (var i = 0; i < bloomFilters.length; i++) {
    final b = bloomFilters[i];
    if (b.mightContain(codePoint)) {
      yield i;
    }
  }
}

typedef VersionConverter = String Function(int);

String supportedString(
  List<int> platformIndices,
  VersionConverter versionConverter,
  String osName,
  double share,
) {
  if (platformIndices.isEmpty) {
    return '$osName unsupported';
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
  final withoutShare = '$osName ${rangeStrings.join(', ')}';

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
