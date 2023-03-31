import 'dart:collection';
import 'dart:math';

/// [TrieEngine] uses Trie Datastructure to store the data
/// supports alphanumeric characters
/// Each node of our Trie is represented by [TrieNode]
class TrieEngine {
  /// [_rootNode] is the root node of the Trie which is created whenever
  /// an instance of [TrieEngine] is initialzed
  final TrieNode _rootNode = TrieNode();

  /// HashMap [_mp] stores the occurences of a string
  final Map<String, int> _mp = {};

  /// The below ordered HashMap [_priorityMp] stores the LevenshteinDistance
  /// of the words generated using [_getLevenshteinDistance]
  final SplayTreeMap<int, List<String>> _priorityMp =
      SplayTreeMap<int, List<String>>();

  List<String>? _list;

  /// The constuctor for [TrieEngine] which takes in an array of string
  /// and inserts all the strings into our Trie
  TrieEngine({required List<String> src}) {
    _list = src;
    for (int idx = 0; idx < src.length; idx++) {
      insertWord(src[idx]);
    }
  }

  // /// [TrieEngine.fromList] is a factory method to create a [TrieEngine] from an array
  // /// of strings
  // factory TrieEngine.fromList(List<String> src) {
  //   TrieEngine t = TrieEngine();
  //   for (int idx = 0; idx < src.length; idx++) {
  //     t.insertWord(src[idx]);
  //   }
  //   return t;
  // }

  /// get all the word occurences and count present in the trie
  Map<String, int> getAllOccurences() => _mp;

  /// total occurences of the given word
  int totalOccurence(String word) => _mp[word] ?? 0;

  /// recursively inserts the given word character by character into the [TrieEngine]
  void _insertWord(String word, int i, TrieNode trieNode) {
    if (i == word.length) {
      trieNode.isWord = true;
      _mp[word] = 1;
      return;
    }
    String currChar = word[i];
    if (trieNode.c[currChar.getIndex] == null) {
      trieNode.c[currChar.getIndex] = TrieNode();
    }
    _insertWord(word, i + 1, trieNode.c[currChar.getIndex]!);
  }

  /// uses dynamic programming approach to efficiently calculate the Levenshtein distance between two strings
  int _getLevenshteinDistance(String str1, String str2) {
    List<List<int>> dp = List.generate(
        str1.length + 1, (_) => List.generate(str2.length + 1, (_) => 0));
    for (int i = 0; i < str1.length + 1; i++) {
      for (int j = 0; j < str2.length + 1; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else {
          if (str1[i - 1] == str2[j - 1]) {
            dp[i][j] = dp[i - 1][j - 1];
          } else {
            dp[i][j] = min(dp[i - 1][j], dp[i][j - 1]) + 1;
          }
        }
      }
    }
    return dp[str1.length][str2.length];
  }

  /// auto corrects the given string
  /// return null if a close match doesn't exist
  String? autoCorrect(String word) {
    word = word.sanitizeString;
    if (_mp.containsKey(word)) return null;
    _priorityMp.clear();
    // List<String> res = autoCompleteSuggestions(word[0]);
    List<String> res = _list!;
    for (int idx = 0; idx < res.length; idx++) {
      int dx = _getLevenshteinDistance(res[idx], word);
      if (_priorityMp.containsKey(dx)) {
        _priorityMp[dx]!.add(res[idx]);
      } else {
        _priorityMp[dx] = [res[idx]];
      }
    }
    return _priorityMp.isNotEmpty
        ? _priorityMp[_priorityMp.firstKey()]?.first
        : null;
  }

  /// returns a list of suggestions to auto correct the given word
  List<String> autoCorrectSuggestions(String word, {int count = 5}) {
    word = word.sanitizeString;
    if (_mp.containsKey(word)) return [];
    _priorityMp.clear();
    List<String> res = _list!;
    for (int idx = 0; idx < res.length; idx++) {
      int dx = _getLevenshteinDistance(res[idx], word);
      if (_priorityMp.containsKey(dx)) {
        _priorityMp[dx]!.add(res[idx]);
      } else {
        _priorityMp[dx] = [res[idx]];
      }
    }
    List<List<String>> s = _priorityMp.values.toList();
    List<String> r = [];
    for (int i = 0, c = 0; i < s.length; i++) {
      for (int j = 0; j < s[i].length; j++, c++) {
        if (c >= count) break;
        r.add(s[i][j]);
      }
    }
    return r;
  }

  /// returns a list of suggestions to auto complete the given word
  List<String> autoCompleteSuggestions(String searchWord) {
    searchWord = searchWord.sanitizeString;
    TrieNode? trieNode = _getSearchStartNode(searchWord, 0, _rootNode);
    if (trieNode == null) return [];
    List<String> results = [];
    _generateAutoCompleteResults(searchWord, searchWord, results, trieNode);
    return results;
  }

  // ignore: unused_element
  TrieNode? _getFalseNode(TrieNode trieNode, String word, int i) {
    if (trieNode.c[i] != null) {
      return _getFalseNode(trieNode.c[i]!, word, i + 1);
    }
    return trieNode.c[i];
  }

  /// auto completes the given string to the first suggestion in alphabetic order
  String? autoComplete(String searchWord) {
    searchWord = searchWord.sanitizeString;
    TrieNode? trieNode = _getSearchStartNode(searchWord, 0, _rootNode);
    if (trieNode == null) return null;
    return _getTopSuggestion(searchWord, trieNode, searchWord);
  }

  /// returns an alphabetically sorted list of all the words present in the engine
  List<String> toSortedList() {
    List<String> res = [];
    _generateSortedList('', _rootNode, res);
    return res;
  }

  /// recursively traverses the entire trie and adds the words to [res]
  void _generateSortedList(
      String currWord, TrieNode trieNode, List<String> res) {
    if (trieNode.isWord) {
      res.add(currWord);
    }
    for (int idx = 0; idx < 36; idx++) {
      if (trieNode.c[idx] != null) {
        _generateSortedList(
            currWord + idx.charFromIndex, trieNode.c[idx]!, res);
      }
    }
  }

  String _getTopSuggestion(
      String searchWord, TrieNode trieNode, String currWord) {
    if (trieNode.isWord) {
      return currWord;
    }
    for (int idx = 0; idx < 36; idx++) {
      if (trieNode.c[idx] != null) {
        return _getTopSuggestion(
            searchWord, trieNode.c[idx]!, currWord + idx.charFromIndex);
      }
    }
    return '';
  }

  void _generateAutoCompleteResults(
      String searchWord, String currWord, List<String> res, TrieNode trieNode) {
    if (trieNode.isWord) {
      res.add(currWord);
    }
    for (int idx = 0; idx < 36; idx++) {
      if (trieNode.c[idx] != null) {
        _generateAutoCompleteResults(
            searchWord, currWord + idx.charFromIndex, res, trieNode.c[idx]!);
      }
    }
  }

  /// finds the node from where the auto completion strings should be generated
  TrieNode? _getSearchStartNode(String word, int i, TrieNode trieNode) {
    if (i == word.length) {
      return trieNode;
    } else if (trieNode.c[word[i].getIndex] == null) {
      return null;
    }
    return _getSearchStartNode(word, i + 1, trieNode.c[word[i].getIndex]!);
  }

  /// returns true if the word exists in the engine
  bool contains(String word) => _mp.containsKey(word.sanitizeString);

  /// insert a new word into the engine
  void insertWord(String word) {
    if (_mp.containsKey(word)) {
      _mp[word] = _mp[word]! + 1;
      return;
    }
    _insertWord(word.sanitizeString, 0, _rootNode);
  }
}

class TrieNode {
  /// [c] is an array of possible [TrieNode] instances
  /// If a character doen't exist at certain index, the array will contain a null value at the same
  List<TrieNode?> c = List.filled(36, null);

  /// the flag [isWord] is used to check if at a given node a word gets completed
  bool isWord = false;
}

extension Ext1 on String {
  /// [getIndex] extension on [String] maps alphanumberic characters to index for [TrieNode] array
  int get getIndex {
    if (int.tryParse(this[0]) != null) {
      return int.parse(this[0]) + 26;
    } else {
      return (toLowerCase().codeUnitAt(0)) - 97;
    }
  }

  /// sanitizes the given string into a pure lowercase alphanumberic string
  String get sanitizeString =>
      replaceAll(RegExp("[^A-Za-z0-9]+"), '').toLowerCase();
}

extension Ext2 on int {
  /// the [charFromIndex] extension on [int] converts the given [TrieNode] array index into a character
  String get charFromIndex {
    if (this > 25) {
      return String.fromCharCode((this - 26) + 48);
    } else {
      return String.fromCharCode(this + 97);
    }
  }
}
