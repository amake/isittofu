import 'package:flutter_test/flutter_test.dart';
import 'package:isittofu/data/android.dart' as android;
import 'package:isittofu/data/ios.dart' as ios;

void main() {
  test('ASCII sanity test', () {
    for (final rune in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
            'abcdefghijklmnopqrstuvwxyz'
            '0123456789'
        .runes) {
      for (final pattern in android.patterns.followedBy(ios.patterns)) {
        expect(pattern.hasMatch(String.fromCharCode(rune)), true);
      }
    }
  });

  test('distributions', () {
    expect(ios.distribution.reduce((a, b) => a + b), 1);
    expect(android.distribution.reduce((a, b) => a + b), 1);
  });
}
