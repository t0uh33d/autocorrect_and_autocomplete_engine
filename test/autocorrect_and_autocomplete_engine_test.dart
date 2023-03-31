import 'dart:io';

import 'package:autocorrect_and_autocomplete_engine/autocorrect_and_autocomplete_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

TrieEngine trieEngine =
    TrieEngine(src: File('../../../10k_words.txt').readAsLinesSync());
void main() {
  test('auto complete', () {
    if (kDebugMode) {
      print(trieEngine.autoComplete('marv'));
    }
  });

  test('auto complete suggestions', () {
    if (kDebugMode) {
      print(trieEngine.autoCompleteSuggestions('mar'));
    }
  });

  test('auto correct', () {
    if (kDebugMode) {
      print(trieEngine.autoCorrect('narvel'));
    }
  });

  test('auto correct suggestions', () {
    if (kDebugMode) {
      print(trieEngine.autoCorrectSuggestions('marxvl', count: 10));
    }
  });

  test('sorting', () {
    // correct order of names
    List<String> arr = [
      "Acetobacter aurantius",
      "Acinetobacter baumannii",
      "Actinomyces israelii",
      "Agrobacterium radiobacter",
      "Agrobacterium tumefaciens",
      "Anaplasma",
      "Anaplasma phagocytophilum",
      "Azorhizobium caulinodans",
      "Azotobacter vinelandii"
    ];
    String sortedStr = arr.join().replaceAll(' ', '').toLowerCase();
    arr.shuffle();
    TrieEngine trieEngine = TrieEngine(src: arr);
    expect(trieEngine.toSortedList().join(), sortedStr);
  });
}
