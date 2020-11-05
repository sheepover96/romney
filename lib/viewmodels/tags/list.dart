import 'package:flutter/material.dart';

import 'package:romney/usecases/tags/tags_usecase.dart';
import 'package:romney/entities/tag.dart';
import 'package:romney/entities/tag_with_nwords.dart';

class TagListViewModel extends ChangeNotifier {
  final TagsUsecase tagsUsecase = TagsUsecase();
  List tagList = [];

  TagListViewModel();

  // List<Word> getList() {
  List getList() {
    return tagList;
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
