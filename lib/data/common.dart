import 'package:bloom_filter/bloom_filter.dart';

Iterable<int> supportingIndices(
    int codePoint, List<BloomFilter> bloomFilters) sync* {
  for (int i = 0; i < bloomFilters.length; i++) {
    final b = bloomFilters[i];
    if (b.mightContain(codePoint)) {
      yield i;
    }
  }
}

typedef VersionConverter = String Function(int);

String supportedString(
  List<List<int>> ranges,
  VersionConverter versionConverter,
  String osName,
) {
  if (ranges.isEmpty) {
    return '$osName unsupported';
  }
  final rangeStrings = ranges.map((range) {
    assert(range.length == 2);
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
