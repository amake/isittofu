import 'dart:io';

import 'package:bloom_filter/bloom_filter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isittofu/data/android.dart' as android;
import 'package:isittofu/data/ios.dart' as ios;

void main() {
  test('false positive rates', () {
    final file = File('lib/data/android10.txt');
    final lines = file.readAsLinesSync().where((line) => line.isNotEmpty);
    for (final p in [0.1, 0.01]) {
      final b = BloomFilter.withProbability(p, lines.length);
      b.addAll(lines);
      expect(b.containsAll(lines), true);
      final linesSet = Set.from(lines);
      int falsePositives = 0;
      for (int i = 0; i < 0x10ffff; i++) {
        final l = i.toString();
        if (!linesSet.contains(l) && b.mightContain(i)) {
          //print('False positive: $l');
          falsePositives++;
        }
      }
      final actualP = falsePositives / 0x10ffff;
      print('Probability: $p');
      print('False positive rate: $falsePositives/${0x10ffff} '
          '(${actualP * 100}%)');
      print('Bit size: ${b.bitVectorSize}');
      expect(actualP <= p, true);
    }
  });

  test('serialized bloom filter', () {
    for (int i = 2; i <= 29; i++) {
      print('Checking Android $i');
      final file = File('lib/data/android$i.txt');
      final lines = file.readAsLinesSync().where((line) => line.isNotEmpty);
      final serializedFilter = android.bloomFilters[i - 2];
      final newFilter = BloomFilter.withProbability(0.01, lines.length)
        ..addAll(lines);
      expect(newFilter.containsAll(lines), true);
      expect(
          listEquals(newFilter.bitVectorListForStorage(),
              serializedFilter.bitVectorListForStorage()),
          true);
      expect(newFilter.bitVectorSize == serializedFilter.bitVectorSize, true);
      expect(listEquals(newFilter.getBits(), serializedFilter.getBits()), true);
      for (final line in lines) {
        expect(serializedFilter.mightContain(line), true);
      }
    }
  });

  test('ASCII sanity test', () {
    for (final rune in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
            'abcdefghijklmnopqrstuvwxyz'
            '0123456789'
        .runes) {
      for (final filter in android.bloomFilters.followedBy(ios.bloomFilters)) {
        expect(filter.mightContain(rune), true);
      }
    }
  });
}