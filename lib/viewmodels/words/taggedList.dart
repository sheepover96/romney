import 'package:flutter/material.dart';

import 'package:romney/usecases/words/words_usecase.dart';
import 'package:romney/entities/word.dart';
import 'package:romney/entities/tag.dart';
import 'package:romney/viewmodels/words/list_if.dart';

class TaggedWordListViewModel extends ChangeNotifier
    implements IWordListViewModel {
  final WordsUsecase wordsUsecase = WordsUsecase();
  Tag tag;
  List<Word> wordList = [];

  TaggedWordListViewModel({@required this.tag});

  // List<Word> getList() {
  List getList() {
    return wordList;
  }

  Word getOne(int index) {
    return wordList[index];
  }

  Future addWord(String newWord) {
    wordList.add(Word(word: newWord));
    notifyListeners();
    return Future.value("succeed");
  }

  Future deleteOne(Word word) async {
    this.wordList.removeWhere((e) => e.id == word.id);
    notifyListeners();
  }

  Future<String> fetchTaggedWords() async {
    final res = await wordsUsecase.getTaggedWordListWithTag(tag);
    if (res != null) {
      this.wordList = res;
    }
    return Future.value("succeed");
  }
}
