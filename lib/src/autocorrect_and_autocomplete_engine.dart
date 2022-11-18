import 'dart:collection';
import 'dart:math';

class TrieEngine {
  final TrieNode _rootNode = TrieNode();
  final Map<String, int> _mp = {};
  final SplayTreeMap<int, List<String>> _priorityMp =
      SplayTreeMap<int, List<String>>();

  TrieEngine({List<String>? src}) {
    if (src == null) return;
    for (int idx = 0; idx < src.length; idx++) {
      insertWord(src[idx]);
    }
  }

  factory TrieEngine.fromList(List<String> res) {
    TrieEngine t = TrieEngine();
    for (int idx = 0; idx < res.length; idx++) {
      t.insertWord(res[idx]);
    }
    return t;
  }

  Map<String, int> getAllOccurences() => _mp;

  int totalOccurence(String word) => _mp[word] ?? 0;

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

  // ignore: unused_element
  bool _searchWord(String word, int i, TrieNode trieNode) {
    if (i == word.length) {
      return trieNode.isWord;
    } else if (trieNode.c[word[i].getIndex] == null) {
      return false;
    }
    return _searchWord(word, i + 1, trieNode.c[word[i].getIndex]!);
  }

  // ignore: unused_element
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

  // ignore: unused_element
  TrieNode? _getFalseNode(TrieNode trieNode, String word, int i) {
    if (trieNode.c[i] != null) {
      return _getFalseNode(trieNode.c[i]!, word, i + 1);
    }
    return trieNode.c[i];
  }

  String? autoCorrect(String word) {
    word = word.sanitizeString;
    if (_mp.containsKey(word)) return null;
    _priorityMp.clear();
    List<String> res = autoCompleteSuggestions(word[0]);
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

  List<String> autoCorrectSuggestions(String word, {int count = 5}) {
    word = word.sanitizeString;
    if (_mp.containsKey(word)) return [];
    _priorityMp.clear();
    List<String> res = autoCompleteSuggestions(word[0]);
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

  List<String> autoCompleteSuggestions(String searchWord) {
    searchWord = searchWord.sanitizeString;
    TrieNode? trieNode = _getSearchStartNode(searchWord, 0, _rootNode);
    if (trieNode == null) return [];
    List<String> results = [];
    _generateAutoCompleteResults(searchWord, searchWord, results, trieNode);
    return results;
  }

  String? autoComplete(String searchWord) {
    searchWord = searchWord.sanitizeString;
    TrieNode? trieNode = _getSearchStartNode(searchWord, 0, _rootNode);
    if (trieNode == null) return null;
    return _getTopSuggestion(searchWord, trieNode, searchWord);
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

  TrieNode? _getSearchStartNode(String word, int i, TrieNode trieNode) {
    if (i == word.length) {
      return trieNode;
    } else if (trieNode.c[word[i].getIndex] == null) {
      return null;
    }
    return _getSearchStartNode(word, i + 1, trieNode.c[word[i].getIndex]!);
  }

  bool contains(String word) => _mp.containsKey(word.sanitizeString);

  void insertWord(String word) {
    if (_mp.containsKey(word)) {
      _mp[word] = _mp[word]! + 1;
      return;
    }
    _insertWord(word.sanitizeString, 0, _rootNode);
  }
}

class TrieNode {
  List<TrieNode?> c = List.filled(36, null);
  bool isWord = false;
}

extension Ext1 on String {
  int get getIndex {
    if (int.tryParse(this[0]) != null) {
      return int.parse(this[0]) + 26;
    } else {
      return (toLowerCase().codeUnitAt(0)) - 97;
    }
  }

  String get sanitizeString =>
      replaceAll(RegExp("[^A-Za-z0-9]+"), '').toLowerCase();
}

extension Ext2 on int {
  String get charFromIndex {
    if (this > 25) {
      return String.fromCharCode((this - 26) + 48);
    } else {
      return String.fromCharCode(this + 97);
    }
  }
}
