## Features

A simple and efficient autocorrection and autocomplete engine built with Tries for Flutter.

- Autocomplete a given string
- Generate a list of Autocomplete suggestions for the given string
- Autocorrect a given string
- Generate a list of Autocorrect suggestions for the given string
- Sort the given list alphabetically

## Getting started

Add the package to your `pubsec.yaml`

```dart
dependencies:
    autocorrect_and_autocomplete_engine:
```

import the package in a file

```dart
import 'package:autocorrect_and_autocomplete_engine/autocorrect_and_autocomplete_engine.dart';
```

## Usage

#### Initialization

- `TrieEngine` needs a list of string to work with for autocompletion and autocorrection.

  ```dart
  List<String> testData = ["compete","ability","baker","abilities","able"];
  ```

- Initializing the TrieEngine with `testData`

  ```dart
  TrieEngine trieEngine = TrieEngine(src : testData);

  //or

  TrieEngine trieEngine = TrieEngine.fromList(testData);
  ```

- Initialize `TrieEngine` using the list of words in a [file](https://www.mit.edu/~ecprice/wordlist.10000)

  ```dart
  TrieEngine trieEngine = TrieEngine.fromList(File('PATH_TO_FILE').readAsLinesSync());
  ```

#### Inserting a new string

```dart
trieEngine.insertWord('awesome');
```

#### Using Autocomplete

- Use `autoComplete()` to Autocomplete the given string based on alpabetic order

  ```dart
  String result = trieEngine.autoComplete('marv');
  print(result); // marvel
  ```

- Use `autoCompleteSuggestions()` to generate a list of suggestions for autocompletion

  ```dart
  List<String> result = trieEngine.autoCompleteSuggestions('marv');
  print(result); // [mar, marathon, marble, marc, march, ...]
  ```

#### Using Autocorrect

- Use `autoCorrect()` to Autocorrect the given string

  ```dart
  String result = trieEngine.autoCorrect('marxvl');
  print(result); // marvel
  ```

- Use `autoCorrectSuggestions()` to generate a list of suggestions for autocorrection

  ```dart
  List<String> result = trieEngine.autoCorrectSuggestions('marxvl');
  print(result); // [marvel, mar, max, ma, mail, male, mali, mall, marble, marc]
  ```

#### Sort the list alphabetically

use `toSortedList()` to generate a alphabetically sorted list for the given testData

```dart
List<String> listToSort = ["compete","ability","baker","abilities","able"];

TrieEngine trieEngine = TrieEngine(src : listToSort);

List<String> sortedList = trieEngine.toSortedList();

print(sortedList); // [abilities, ability, able, baker, compete]
```
