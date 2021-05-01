import 'package:flutter/material.dart';

import 'package:romney/usecases/tags/tags_usecase.dart';
import 'package:romney/entities/tag.dart';
import 'package:romney/entities/tag_with_nwords.dart';

import '../../usecases/words/words_usecase.dart';

class TagListViewModel extends ChangeNotifier {
  final TagsUsecase tagsUsecase = TagsUsecase();
  final WordsUsecase wordsUsecase = WordsUsecase();
  List tagList = [];
  int nFavorite;

  TagListViewModel();

  // List<Word> getList() {
  List getList() {
    return tagList;
  }

  Future<int> fetchNFavorite() async {
    final res = await wordsUsecase.countNFavorite();
    if (res == null) return Future.error(res);
    this.nFavorite = res;
    return Future.value(res);
  }

  TagWithNwords getOne(int index) {
    return tagList[index];
  }

  Future deleteOne(Tag tag) async {
    this.tagList.removeWhere((e) => e.id == tag.id);
    notifyListeners();
  }

  Future addTag(String newTag) {
    print(newTag);
    tagList.add(TagWithNwords(tag: newTag));
    notifyListeners();
    return Future.value("succeed");
  }

  Future<String> fetchTags() async {
    final res = await tagsUsecase.getListWithNWords();
    if (res != null) {
      this.tagList = res;
    }
    return Future.value("succeed");
  }
}
