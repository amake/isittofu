extension IterUtils<T> on Iterable<T> {
  Iterable<T> unique() sync* {
    final seen = Set<T>();
    for (final item in this) {
      if (!seen.contains(item)) {
        yield item;
        seen.add(item);
      }
    }
  }
}
