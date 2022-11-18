// ignore_for_file: avoid_print
import 'dart:io';

import 'package:autocorrect_and_autocomplete_engine/autocorrect_and_autocomplete_engine.dart';
import 'package:flutter_test/flutter_test.dart';

bool search(String word) {
  return testData.contains(word);
}

List<String> getSuggestions(String word) {
  return testData
      .where((element) => element.toLowerCase().startsWith(word.toLowerCase()))
      .toList();
}

String getFirstSuggestions(String word) {
  return testData
      .where((element) => element.toLowerCase().startsWith(word.toLowerCase()))
      .first;
}

String searchWord = 'abc';
List<String> testData =
    File('/Users/codewave/Desktop/10k_words.txt').readAsLinesSync();
void main() {
  test('test 1', () {
    TrieEngine trie = TrieEngine(src: testData);

    print("\n\nSearching the word \"$searchWord\" using tries \n");
    DateTime startTime = DateTime.now();
    print("Result : ${trie.contains(searchWord)}");
    print(
        "Time taken : ${DateTime.now().difference(startTime).inMicroseconds} microseconds");
  });

  test('test 1', () {
    print("\n\nSearching the word \"$searchWord\" using built in contains");
    DateTime startTime = DateTime.now();
    print("Result : ${search(searchWord)}");
    print(
        "Time taken : ${DateTime.now().difference(startTime).inMicroseconds} microseconds");
  });

  // suggestion time
  test('test 2', () {
    TrieEngine trie = TrieEngine(src: testData);
    print(
        "\n\nSuggestions for words starting with \"$searchWord\" using tries \n");
    DateTime startTime = DateTime.now();
    print("Result : ${trie.autoComplete(searchWord)}");
    print(
        "Time taken : ${DateTime.now().difference(startTime).inMicroseconds} microseconds");
  });

  test('test 2', () {
    print(
        'Suggestions for words starting with "$searchWord" using built in startsWith');
    DateTime startTime = DateTime.now();
    print("Result : ${getSuggestions(searchWord)}");
    print(
        "Time taken : ${DateTime.now().difference(startTime).inMicroseconds} microseconds");
  });

  test('test 3', () {
    TrieEngine trie = TrieEngine(src: testData);
    print("\ntop for word starting with \"$searchWord\" using tries \n");
    DateTime startTime = DateTime.now();
    print("Result : ${trie.autoComplete(searchWord) ?? 'No suggestion found'}");
    print(
        "Time taken : ${DateTime.now().difference(startTime).inMicroseconds} microseconds");
  });

  test('test 3', () {
    print(
        'Suggestions for words starting with "$searchWord" using built in startsWith');
    DateTime startTime = DateTime.now();
    print("Result : ${getFirstSuggestions(searchWord)}");
    print(
        "Time taken : ${DateTime.now().difference(startTime).inMicroseconds} microseconds");
  });

  test('test 4', () {
    TrieEngine trie = TrieEngine(src: testData);
    DateTime startTime = DateTime.now();
    print(trie.autoCorrectSuggestions('helicoptar', count: 6));
    print(
        "Time taken : ${DateTime.now().difference(startTime).inMicroseconds} microseconds");
  });
}
