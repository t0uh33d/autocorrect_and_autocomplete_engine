// ignore_for_file: avoid_print
import 'dart:io';

import 'package:autocorrect_and_autocomplete_engine/autocorrect_and_autocomplete_engine.dart';
import 'package:flutter_test/flutter_test.dart';

TrieEngine trieEngine = TrieEngine.fromList(
    File('/Users/codewave/Desktop/10k_words.txt').readAsLinesSync());
void main() {
  test('auto complete', () {
    print(trieEngine.autoComplete("marv"));
  });

  test('auto complete suggestions', () {
    print(trieEngine.autoCompleteSuggestions('mar'));
  });

  test('auto correct', () {
    print(trieEngine.autoCorrect('marve'));
  });

  test('auto correct suggestions', () {
    print(trieEngine.autoCorrectSuggestions('helikopta', count: 10));
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
    TrieEngine trieEngine = TrieEngine.fromList(arr);
    expect(trieEngine.toSortedList().join(), sortedStr);
  });
}
