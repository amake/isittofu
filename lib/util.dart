import 'package:flutter/foundation.dart';

void logDebug(String message) {
  if (!kReleaseMode) {
    debugPrint(message);
  }
}

extension IterUtils<T> on Iterable<T> {
  Iterable<T> unique() sync* {
    final seen = <T>{};
    for (final item in this) {
      if (!seen.contains(item)) {
        yield item;
        seen.add(item);
      }
    }
  }
}

typedef Range = ({int to, int from});

extension IntIterUtils on Iterable<int> {
  List<Range> ranges() {
    if (isEmpty) {
      return [];
    }
    return fold<List<Range>>(<Range>[], (acc, idx) {
      if (acc.isEmpty || acc.last.to + 1 < idx) {
        acc.add((from: idx, to: idx));
      } else {
        acc.last = (from: acc.last.from, to: idx);
      }
      return acc;
    });
  }
}
