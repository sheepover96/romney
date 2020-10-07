import 'package:flutter/material.dart';

import 'package:romney/usecases/tags/tags_usecase.dart';
import 'package:romney/entities/tag.dart';

class TagListViewModel extends ChangeNotifier {
  final TagsUsecase tagsUsecase = TagsUsecase();
  List<Tag> tagList = [];

  TagListViewModel();

  // List<Word> getList() {
  List getList() {
    return tagList;
  }

  Tag getOne(int index) {
    return tagList[index];
  }

  Future addTags(String newTag) {
    tagList.add(Tag(tag: newTag));
    notifyListeners();
    return Future.value("succeed");
  }

  Future<String> fetchTags() async {
    final res = await tagsUsecase.getList();
    if (res != null) {
      this.tagList = res;
    }
    return Future.value("succeed");
  }
}
