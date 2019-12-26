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
  return '$osName ${rangeStrings.join(', ')}';
}
