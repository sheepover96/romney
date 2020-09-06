import 'package:flutter/material.dart';

import 'package:romney/usecases/tags/tags_usecase.dart';
import 'package:romney/entities/tag.dart';

class TagAddViewModel extends ChangeNotifier {
  final TagsUsecase tagsUsecase = TagsUsecase();
  String _tag = "";

  TagAddViewModel();

  get tag => _tag;
  set tag(tag) {
    this._tag = tag;
  }

  Future add() async {
    final newTag = Tag(
      tag: _tag,
      createdAt: DateTime.now(),
    );
    await tagsUsecase.insert(newTag);
  }
}
