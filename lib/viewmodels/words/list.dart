import 'package:flutter/material.dart';

import 'package:romney/usecases/words/words_usecase.dart';
import 'package:romney/entities/word.dart';

class WordViewModel extends ChangeNotifier {
  final WordsUsecase wordsUsecase = WordsUsecase();
  List<Word> wordList = [];

  WordViewModel();

  // List<Word> getList() {
  List getList() {
    return wordList;
  }

  Word getOne(int index) {
    return wordList[index];
  }

  Future deleteOne(Word word) async {
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
    // final res = await wordsUsecase.getList();
    if (res != null) {
      this.wordList = res;
    }
    return Future.value("succeed");
  }
}
