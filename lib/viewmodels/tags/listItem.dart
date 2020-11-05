import 'package:flutter/material.dart';

import 'package:romney/usecases/tags/tags_usecase.dart';
import 'package:romney/usecases/tags/tags_usecase_if.dart';
import 'package:romney/entities/tag.dart';

class TagListItemViewModel extends ChangeNotifier {
  final ITagsUsecase tagsUsecase = TagsUsecase();
  Tag tag;

  TagListItemViewModel({@required this.tag});

  // Future updateIsFavorite() async {
  //   await tagsUsecase.updateIsFavorite(this.word);
  //   this.word.isFavorite = !this.word.isFavorite;
  //   notifyListeners();
  // }

  Future delete() async {
    await tagsUsecase.delete(this.tag);
    notifyListeners();
  }

  // Future updateIsFavorite(int wordID) {}
}
