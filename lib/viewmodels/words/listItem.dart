import 'package:flutter/material.dart';

import 'package:romney/usecases/words/words_usecase.dart';
import 'package:romney/entities/word.dart';

class WordListItemViewModel extends ChangeNotifier {
  final WordsUsecase wordsUsecase = WordsUsecase();
  Word word;

  WordListItemViewModel({@required this.word});

  Future updateIsFavorite() async {
    await wordsUsecase.updateIsFavorite(this.word);
    this.word.isFavorite = !this.word.isFavorite;
    notifyListeners();
  }

  Future delete() async {
    await wordsUsecase.delete(this.word);
    this.word.isFavorite = !this.word.isFavorite;
    notifyListeners();
  }

  // Future updateIsFavorite(int wordID) {}
}
