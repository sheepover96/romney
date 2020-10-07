import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:romney/usecases/words/words_usecase.dart';
import 'package:romney/entities/word.dart';
import 'package:romney/usecases/tags/tags_usecase.dart';
import 'package:romney/entities/tag.dart';

class WordAddViewModel extends ChangeNotifier {
  final platform = const MethodChannel('dictionary_search');
  final WordsUsecase wordsUsecase = WordsUsecase();
  final TagsUsecase tagsUsecase = TagsUsecase();
  bool _isProcessing = false;

  String _word = "";
  bool _isWordValid = false;
  String _meaning = "";
  String _reading = "";
  Tag _tag;
  List<Tag> tagList = [];

  WordAddViewModel({String word: ""}) {
    this._word = word;
  }

  get word => _word;
  set word(word) {
    this._word = word;
    this._isWordValid = (this._word.length != 0);
    notifyListeners();
  }

  get isWordValid => _isWordValid;

  get meaning => _meaning;
  set meaning(meaning) {
    this._meaning = meaning;
    notifyListeners();
  }

  get reading => _reading;
  set reading(reading) {
    this._reading = reading;
    notifyListeners();
  }

  get tag => _tag;
  set tag(tag) {
    this._tag = tag;
    notifyListeners();
  }

  get isProcessing => _isProcessing;

  Future isWordInDictionary(String word) async {
    String dictionaryLevel;
    try {
      final res = await platform.invokeMethod(
          'isWordInDictionary', <String, dynamic>{"queryWord": word});
      return res;
    } on PlatformException catch (e) {
      print(e);
      dictionaryLevel = "Failed to search dictionary";
      return false;
    }
  }

  Future add() async {
    this._isProcessing = true;
    notifyListeners();

    final isInDictionary = await isWordInDictionary(_word);
    final newWord = Word(
      word: _word,
      meaning: _meaning,
      reading: _reading,
      tag: _tag,
      isInDictionary: isInDictionary,
      createdAt: DateTime.now(),
    );
    await this.wordsUsecase.insert(newWord);

    this._isProcessing = false;
    notifyListeners();
  }

  Future<String> fetchTags() async {
    try {
      final res = await tagsUsecase.getList();
      if (res != null) {
        this.tagList = res;
      }
      return Future.value("success");
    } catch (e) {
      return Future.error(e);
    }
  }
}
