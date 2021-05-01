import 'package:flutter/material.dart';

import 'package:romney/usecases/words/words_usecase.dart';
import 'package:romney/entities/word.dart';
import 'package:romney/entities/tag.dart';
import 'package:romney/viewmodels/words/list_if.dart';

class WordViewModel extends ChangeNotifier implements IWordListViewModel {
  final WordsUsecase wordsUsecase = WordsUsecase();
  List<Word> wordList = [];
  int nFavorite;

  WordViewModel();

  // List<Word> getList() {
  List getList() {
    return wordList;
  }

  List getListByTag() {
    return wordList;
  }

  List getListFilteredByTag(Tag tag) {
    return wordList.where((w) {
      if (w.tag != null) {
        return (w.tag.id == tag.id);
      }
      return false;
    }).toList();
  }

  List getListFavorite() {
    return wordList.where((w) {
      return w.isFavorite;
    }).toList();
  }

  Future<int> fetchNFavorite() async {
    final res = await wordsUsecase.countNFavorite();
    if (res == null) return Future.error(res);
    this.nFavorite = res;
    return Future.value(res);
  }

  Word getOne(int index) {
    return wordList[index];
  }

  Future deleteOne(Word word) async {
    await wordsUsecase.delete(word);
    this.wordList.removeWhere((e) => e.id == word.id);
    notifyListeners();
  }

  Future addWord(String newWord) {
    wordList.add(Word(word: newWord));
    notifyListeners();
    return Future.value("succeed");
  }

  Future<String> fetchWords() async {
    final res = await wordsUsecase.getWordListWithTag();
    if (res != null) {
      this.wordList = res;
    }
    return Future.value("succeed");
  }

  Future<String> fetchTaggedWords(Tag tag) async {
    final res = await wordsUsecase.getTaggedWordListWithTag(tag);
    if (res != null) {
      this.wordList = res;
    }
    return Future.value("succeed");
  }
}
