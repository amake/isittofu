import 'dart:html';

import 'package:flutter/foundation.dart';

void logDebug(String message) {
  if (!kReleaseMode) {
    print(message);
  }
}

extension WindowUtils on Window {
  void setQuery(String string) => history.pushState(
      null, null, '?${Uri.encodeQueryComponent(string)}${location.hash}');

  String get decodedQuery {
    final query = location.search;
    return query == null || query.isEmpty
        ? null
        // Remove leading '?'
        : Uri.decodeQueryComponent(query.substring(1));
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

extension IntIterUtils on Iterable<int> {
  List<List<int>> ranges() {
    if (isEmpty) {
      return [];
    }
    return fold<List<List<int>>>(<List<int>>[], (acc, idx) {
      if (acc.isEmpty || acc.last[1] + 1 < idx) {
        acc.add([idx, idx]);
      } else {
        acc.last[1] = idx;
      }
      return acc;
    });
  }
}
